import gzip
import os
import shutil

import pandas as pd
import requests
import sqlalchemy
from tqdm import tqdm

chunk_size = 10000

taxi_file_path = "csv_files/yellow_tripdata_2021-01.csv"
url_taxi_file = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz"

zones_file_path = "csv_files/taxi_zone_lookup.csv"
url_zones_file = (
    "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"
)

psql_user = "postgres"
psql_pass = "postgres"
psql_host = "postgres"
psql_port = "5432"
psql_db = "ny_taxi"


def download_file(url, output_file):
    """Downloads a file from a given URL and saves it to the output file.
    If the file is a .gz file it will be unzipped on the fly.
    """
    print(f"Downloading {url} to {output_file}\n")
    requested_file = requests.get(url, stream=True).raw

    with open(output_file, "wb") as output_file:
        if url.endswith(".gz"):
            print(f"Unzipping {output_file}\n")
            requested_file = gzip.GzipFile(fileobj=requested_file)

        print(f"Saving {url} to {output_file}\n")
        shutil.copyfileobj(requested_file, output_file)


def data_tranformation(df):
    # Dates are read as strings, convert them to datetime
    df["lpep_pickup_datetime"] = pd.to_datetime(df["lpep_pickup_datetime"])
    df["lpep_dropoff_datetime"] = pd.to_datetime(df["lpep_dropoff_datetime"])
    return df


def main():
    """Ingests data from CSVs into the PostgreSQL DB.
    If the file is not found it will be downloaded from a URL and saved to the
    specified location.
    """
    print("Checking if files already exist...\n")
    if not os.path.exists(taxi_file_path) or not os.path.exists(zones_file_path):
        print("Files do not exist.\n")
        os.makedirs("csv_files", exist_ok=True)
        print("Downloading files...\n")
        download_file(url_taxi_file, taxi_file_path)
        download_file(url_zones_file, zones_file_path)
    else:
        print("Files already exist.\n")

    conn = sqlalchemy.create_engine(
        f"postgresql://{psql_user}:{psql_pass}@{psql_host}:{psql_port}/{psql_db}"
    )

    print("Reading zones file and inserting it into the database...\n")
    df = pd.read_csv(zones_file_path)
    df.to_sql(name="taxi_zone_lookup", con=conn, if_exists="replace")

    print("Reading taxi data and inserting it into the database...\n")
    df = pd.read_csv(taxi_file_path, iterator=True, chunksize=chunk_size)

    with conn.connect() as con:
        con.execute(sqlalchemy.text("DROP TABLE IF EXISTS yellow_taxi_data"))
        con.commit()

    with open(taxi_file_path, "rb") as f:
        total_chunks = sum(1 for _ in f) // chunk_size

    for chunk in tqdm(df, total=total_chunks, desc="Inserting taxi data"):
        chunk = data_tranformation(chunk)
        chunk.to_sql(name="yellow_taxi_data", con=conn, if_exists="append")

    print("Done!")


if __name__ == "__main__":
    main()
