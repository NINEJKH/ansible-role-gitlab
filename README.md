[![Build Status](https://travis-ci.org/NINEJKH/ansible-role-gitlab.svg?branch=master)](https://travis-ci.org/NINEJKH/ansible-role-gitlab)

# NINEJKH.gitlab

## Local test

```bash
$ ./test.sh -i 192.168.56.103 -u vbox
```

## Requirements

* working MySQL server
  * `SET GLOBAL innodb_file_per_table=1, innodb_file_format=Barracuda, innodb_large_prefix=1, log_bin_trust_function_creators = 1;`
* working Redis server

## Role Variables

```yaml

go_version: 1.8.7

gitlab_version: 10-6-stable

gitlab_fqdn: gitlab

gitlab_root_email: root@gitlab

gitlab_root_password: Foobar_2k18

gitlab_unicorn_worker_processes: 3

gitlab_redis_url: redis://127.0.0.1:6379

gitlab_mysql_db: gitlabhq_production

gitlab_mysql_user: git

gitlab_mysql_pass: ''

gitlab_mysql_host: 127.0.0.1

gitlab_enable_ssl: yes

gitlab_db_key_base:

gitlab_secret_key_base:

gitlab_otp_key_base:

gitlab_jws_private_key:

gitlab_backup_provider:

gitlab_backup_region:

gitlab_backup_aws_access_key_id:

gitlab_backup_aws_secret_access_key:

gitlab_backup_remote_directory:

```

## Example Playbook

```yaml

- hosts: gitlabs
  roles:
    - { role: NINEJKH.gitlab }
```

## License

Licensed under the MIT License. See the [LICENSE file](LICENSE) for details.

## Author Information

[9JKH (Pty) Ltd.](https://9jkh.co.za)
