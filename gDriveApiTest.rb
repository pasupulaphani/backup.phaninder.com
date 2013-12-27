require 'json'

require_relative './GApiClient'
require_relative './GDrive'
require_relative './GDriveUtils'
include GDriveUtils

config_file = '/etc/phaninder.com/backup.json';
env         = ENV['BACKUP_ENV'] || 'dev'
config      = JSON.parse(IO.read(config_file))[env];

p12_key_file = config['p12_key_file']
passphrase   = config['passphrase']
scope        = config['scope']
issuer       = config['issuer']

client   = GApiClient.new(p12_key_file,passphrase, scope, issuer).client

def backup_a_file(client, config)
  backup_folder = get_backup_folder(client, config['backup_folder'])

  GDrive::insert_file(client, "apitest.jpeg", "test", "image/jpeg", "apitest.jpeg", backup_folder.id)
end

# backup_a_file(client, config)
# show_backup_list(client, config)
# download_backup_files(client, config, 'test')