# metview

The European Centre for Medium-Range Weather Forecast ([ECMWF](https://www.ecmwf.int)) provides the metview software package which can be used to inspect, analyse, process and visualze meteorological data. ECMWF also provides a Python interface for it. We have created a simple Docker image to make use of the [metview bundle](https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle) and prepare the Python bindings. This Dockerfile compiles the metview package for non-interactive use. It is the basis for docker image at https://hub.docker.com/r/meteoiq/metview

## Usage

You can build the docker image tagged _metview_ using 

    docker build -t metview . 

Python scripts using metview can then be executed using 

    docker run metview python3 <scriptname.py>

Included is a folder /examples which provides python scripts showing how the container can be used:
* test_version.py

This script outputs information about the version of metview and other used library. After building
the container as shown above it can be run using

    docker run metview python3 /examples/test_version.py

It also tests if the code was built using the _METVIEW_PYTHON_ONLY_ build option. 


* test_regrid.py

This script downloads a set of parameters and timesteps of the ECMWF HRES model from the
ECMWF Open Data service. It features parallel processing using ProcessPoolExecutor,
calculating derived parameters, regridding the parameters to a different grid and then 
creating atomized grib files as output. It prints information about the memory profile of 
the parallel processes.

The script is run using

    docker run metview python3 /examples/test_regrid.py

The example shows that metview cannot be run using _spawn_ type multiprocessing and 
that the memory usage accumulates when doing calculations with the Fieldset.

[MeteoIQ](https://www.meteoiq.com)
