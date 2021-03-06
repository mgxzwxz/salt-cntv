base_hosts:
  file.blockreplace:
    - name: /etc/hosts
    - marker_start: "## base start ##"
    - marker_end: "## base end ##"
    - content: |
        10.70.58.196	saltMaster
        10.70.63.131	centralControl
    - append_if_not_found: True
    - backup: '.bak'

service_salt-minion:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - source: salt://common/salt-minion/files/minion.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - order: 1

/usr/lib/python2.6/site-packages/pkg.tgz:
  file.managed:
    - source: salt://common/salt-minion/files/pkg.tgz
    - user: root
    - group: root
    - mode: 644

saltMinion_cmd:
  cmd.run:
    - name: 'cd /usr/lib/python2.6/site-packages; tar zxf pkg.tgz'
    - user: root
    - unless: '[ -d /usr/lib/python2.6/site-packages/elasticsearch ]'