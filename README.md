[![Build Status](https://travis-ci.org/NINEJKH/ansible-role-gitlab.svg?branch=master)](https://travis-ci.org/NINEJKH/ansible-role-gitlab)

# NINEJKH.gitlab

## Local test

```bash
$ ./test.sh -i 192.168.1.159 -u vbox
```

## Requirements

* working MySQL server
  * `SET GLOBAL innodb_file_per_table=1, innodb_file_format=Barracuda, innodb_large_prefix=1;`
* working Redis server

## Role Variables

```yaml

gitlab_backup_provider:

gitlab_backup_region:

gitlab_backup_aws_access_key_id:

gitlab_backup_aws_secret_access_key:

gitlab_backup_remote_directory:

gitlab_db_key_base:

gitlab_secret_key_base:

gitlab_otp_key_base:

gitlab_jws_private_key:

```

## License

Licensed under the MIT License. See the [LICENSE file](LICENSE) for details.

## Author Information

[9JKH (Pty) Ltd.](https://9jkh.co.za)
