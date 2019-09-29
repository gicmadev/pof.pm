#!/bin/bash
# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

# echo an error message before exiting
trap '[ $? -ne 0 ] && echo "\"${last_command}\" command filed with exit code $?."' EXIT

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

USER=pof.pm
SSH_HOST=$USER@$SERVER
BASE=/home/$USER/production
KEEP_RELEASES=2

RELEASEN=$(date -u +%Y%m%d%H%M%S)

echo "Creating release"
ssh $SSH_HOST BASE=$BASE RELEASEN=$RELEASEN 'bash -s' <<'CMD'
 mkdir -vp $BASE/releases/$RELEASEN
CMD

rsync -avzPhc --recursive --files-from=deploy.files . $SSH_HOST:$BASE/releases/$RELEASEN/

ssh $SSH_HOST BASE=$BASE KEEP_RELEASES=$KEEP_RELEASES RELEASEN=$RELEASEN 'bash -s' <<'CMD'
# exit when any command fails
set -e

echo "Launching release"
cd $BASE/releases/$RELEASEN

mv docker-compose.prod.yml docker-compose.yml

echo "Linking shared data"
ln -nfs $BASE/shared/dbdata $BASE/releases/$RELEASEN/
ln -nfs $BASE/shared/.env $BASE/releases/$RELEASEN/

echo "Pulling new version from docker hub"
./containerctl.sh pull

echo "containers up!"
./containerctl.sh up -d --remove-orphans

echo "Linking release"
ln -nfs $BASE/releases/$RELEASEN $BASE/current

cd $BASE/releases

RELEASES=$(ls -1d */ | sort -r)
COUNT=$(echo "$RELEASES" | wc -l)

if [ "$COUNT" -gt "$KEEP_RELEASES" ]; then
  echo "Cleaning old releases"
  echo "$RELEASES" | tail -n +3 | xargs rm -rvf
fi

cd $BASE/releases/$RELEASEN

echo "Migrating ecto"
( ./containerctl.sh run -T --rm app bundle exec rake db:migrate )
CMD

echo
echo "Done!"
echo
