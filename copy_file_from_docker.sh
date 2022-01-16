#!/bin/bash

for f in $(docker exec -it builder /bin/bash -c "cd / && ls hyperion*.deb"); do 
  c=${f//[![:print:]]/};
  echo $c;
  docker cp builder:$c .;
done
