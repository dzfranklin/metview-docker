import metview as mv
from ecmwf.opendata import Client
import os

print("Checking ecmwf.opendata.Client")
gribfilename = "/tmp/msl_24.grib2"
client = Client()
client.retrieve(
    type="fc",
    step=24,
    param=["msl"],
    target=gribfilename,
)
assert os.path.exists(gribfilename)

print("Checking Fieldset")
f = mv.Fieldset(path=gribfilename)
f.describe()

print("Checking gradient of field can be created")
mv.gradient(f)

print("Checking regrid field")
mv.regrid(data=f, grid=[2, 2])
