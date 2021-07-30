

## mProject for automated repository deployment


before using this on Fresh machine you need to install following dependency on your machine.

* rsync
* shc
* git
* etc.



## mProject Plan
```bash
mproject -e project --init -V
```

## mProject build
```bash
#Just Build
mproject -e project:app_name --build -V
mproject -e msend --build -V
```

#### To Sync Code from Source Repo to Destination repository Without change release version.
Youu can update your code and sync code in destination repository without making any change in release version.

```bash
#Just Sync Code from source repo to Destination repository.
mproject -e msend --sync -tV
```

## Create New Release version.
We can use `-r` to create new release in Destination repository. it is single command to sync from source repo to destination repository.

```bash
mproject -e msend --sync -tVr
```

Note:
  - `-r` : To create new release version.
  - `-t` : test encrypted file. as test it will desply version.
  - `-V` : run as verbose mode.

### Copy some extra files from source to destination repository.
We can use `-c` to provide instructions to copy some extra files from source repository to destination repository.

it will copy all the list of files which is listed in  `configs/msend/mcert_files.txt` in project config.



```bash
#cat configs/msend/mcert_files.txt
source_file_path,destination_file_path
test.txt,abc/mcert.txt

mproject -e msend:mcert --sync -c
```
* Whenever you provide `-c` arguments. always make sure you have created file `app_name_files.txt` under config dir.


### Create New Git Repository

```bash
  ./mproject --repo new_repo --create
```
