#!/bin/sh


# === SET UP ENVIROMENT ===
# (if dont have yet) $ brew install node
# $ npm install -g json-server
# ====
# Folder Define
# === Init/Input ===
# ./---------
# ./mockapi.sh
# ./jsons/*.json
# === output ===
# ./db.json

##### Prepare JSON file
# clean up previous generated output
rm db.json

# generate temp file for writting
echo { >> tmp.json
# use all json files in current folder excepted of db.json
cd jsons
for i in *.json
do
    # first create the key; it is the filename without the extension
    echo \"$i\": | sed 's/\.json//' >> ./../tmp.json
    # dump the file's content
    cat "$i" >> ./../tmp.json
    # add a comma afterwards
    echo , >> ./../tmp.json
done
cd ..

# remove the last comma from the file; otherwise it's not valid json
cat tmp.json | sed '$ s/.$//' >> db.json
# remove tempfile
rm tmp.json
# add closing bracket
echo } >> db.json

#### Start json-server
# get the local IP
ip=$(ifconfig | grep 'inet ' | grep -Fv 127.0.0.1 | awk '{print $2}')

# set a default listening port #--routes
port=4000
echo "Local IP $ip & port $port"
json-server --watch db.json --host $ip --port ${port} --routes routes.json

echo "Starting json server on  $ip:$port"
