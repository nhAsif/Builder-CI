#!/bin/bash

set -exv
name_rom=$(grep init $CIRRUS_WORKING_DIR/build.sh -m 1 | cut -d / -f 4)
cd $CIRRUS_WORKING_DIR/rom/$name_rom
rm -rf .repo/local_manifests
command=$(head $CIRRUS_WORKING_DIR/build.sh -n $(expr $(grep 'build/envsetup.sh' $CIRRUS_WORKING_DIR/build.sh -n | cut -f1 -d:) - 1))
only_sync=$(grep 'repo sync' $CIRRUS_WORKING_DIR/build.sh)
bash -c "$command" || true
curl -sO https://api.cirrus-ci.com/v1/task/$CIRRUS_TASK_ID/logs/Sync_rom.log
a=$(grep 'Cannot remove project' Sync_rom.log -m1|| true)
b=$(grep "^fatal: remove-project element specifies non-existent project" Sync_rom.log -m1 || true)
c=$(grep 'repo sync has finished' Sync_rom.log -m1 || true)
d=$(grep 'Failing repos:' Sync_rom.log -n -m1 || true)
e=$(grep 'fatal: Unable' Sync_rom.log || true)
if [[ $a == *'Cannot remove project'* ]]
then
a=$(echo $a | cut -d ':' -f2)
rm -rf $a
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
elif [[ $b == *'remove-project element specifies non-existent'* ]]
then exit 1
elif [[ $c == *'repo sync has finished'* ]]
then true
elif [[ $d == *'Failing repos:'* ]]
then
d=$(expr $(grep 'Failing repos:' Sync_rom.log -n -m 1| cut -d ':' -f1) + 1)
d2=$(expr $(grep 'Try re-running' Sync_rom.log -n -m1 | cut -d ':' -f1) - 1 )
rm -rf $(head -n $d2 Sync_rom.log | tail -n +$d)
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
elif [[ $e == *'fatal: Unable'* ]]
then
rm -rf $(grep 'fatal: Unable' Sync_rom.log | cut -d ':' -f2 | cut -d "'" -f2)
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j$(nproc --all)
else
#- (repo forall -c 'git checkout .' && bash -c "$only_sync") || (find -name shallow.lock -delete && find -name index.lock -delete && bash -c "$only_sync")
exit 1
fi
rm -rf Sync_rom.log
