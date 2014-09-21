import avro.schema
from avro.datafile import DataFileReader, DataFileWriter
from avro.io import DatumReader, DatumWriter

import pandas as pd
import numpy as np

schema = avro.schema.parse(open("country.avsc").read())
writer = DataFileWriter(open("countries.avro", "w"), DatumWriter(), schema)

countries = pd.read_csv('countries.csv')

for c in countries.values:
     writer.append(dict(zip(["name", "country_id", "area_sqkm", "population"], c)))
writer.close()
