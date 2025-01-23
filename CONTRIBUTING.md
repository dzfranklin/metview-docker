# Contributing

## Updating

1. Download the latest release of the metview source bundle
from https://confluence.ecmwf.int/display/METV/The+Metview+Source+Bundle to the root of the repository and delete the
previous release.

2. Update requirements.txt

3. Run `DRY_RUN=1 ./publish.sh`

4. Check the image was built correctly

5. When ready run `./publish.sh` (if you have write access to the container registry)
