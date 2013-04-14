execute "install zend key" do
  command "wget http://repos.zend.com/zend.key -O- |apt-key add -"
  not_if "apt-key list| grep -c zend"
end

execute "install zend repo" do
  command "echo 'deb http://repos.zend.com/zend-server/6.0/deb_ssl1.0 server non-free' >> /etc/apt/sources.list"
  not_if "grep 'http://repos.zend.com/zend-server/6.0/deb_ssl1.0' -c /etc/apt/sources.list"
end

execute "update apt" do
  command "apt-get update -q -y"
end

package "zend-server-php-5.3"
package "apache2-mpm-itk"
package "curl"
package "vim"
package "screen"
package "lynx-cur"
package "mysql-server"
package "php-5.3-apc-zend-server"

#solr extension requirements
package "autoconf"
package "libcurl4-gnutls-dev"
package "libxml2"
package "libxml2-dev"
package "make"

execute "install composer" do
  command "curl -sS https://getcomposer.org/installer | /usr/local/zend/bin/php -- --install-dir=/usr/local/bin"
end

execute "create composer symlink" do
  command "ln -s /usr/local/bin/composer.phar /usr/local/bin/composer"
  only_if "test -f /usr/local/bin/composer.phar"
  not_if "test -L /usr/local/bin/composer"
end

cookbook_file "/etc/profile.d/zend-server.sh" do
  source "zend-server.sh"
  group "root"
  owner "root"
  mode "0644"
end

cookbook_file "/etc/apache2/sites-available/app.conf" do
  source "app.conf"
  group "root"
  owner "root"
end

cookbook_file "/usr/local/zend/lib/php_extensions/solr.so" do
  source "solr.so"
  group "root"
  owner "root"
end

#execute "install solr module" do
#  command "printf \"\n\n\n\" | pecl install -n solr"
#  command "echo 'extension=solr.so' > /usr/local/zend/etc/conf.d/solr.ini"
#  not_if "test -f /usr/local/zend/lib/php_extensions/solr.so"
#end

#php_pear 'solr' do
#  action :install
#end

execute "install solr module" do
  command "echo 'extension=solr.so' > /usr/local/zend/etc/conf.d/solr.ini"
end

execute "disable default site" do
  command "a2dissite default"
end

execute "enable app site" do
  command "a2ensite app.conf"
end

execute "disable zend modules" do
  command "sed -i 's/zend_extension_manager/;zend_extension_manager/g' /usr/local/zend/etc/conf.d/datacache.ini"
  command "sed -i 's/zend_extension_manager/;zend_extension_manager/g' /usr/local/zend/etc/conf.d/optimizerplus.ini"
  command "sed -i 's/zend_extension_manager/;zend_extension_manager/g' /usr/local/zend/etc/conf.d/pagecache.ini"
end

service "apache2" do
  action :restart
end
