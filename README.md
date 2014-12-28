# Facts, The Application
## Display facter facts over HTTP, using Sinatra

A simple [Sinatra](http://www.sinatrarb.com/) application for exposing the data available to [`facter`](http://puppetlabs.com/facter) over HTTP (or HTTPS with an appropriate application proxy). Super handy if you don't have (or can't use) PuppetDB to store fact values for your nodes.

## Available endpoints

<dl>
  <dt>Display facts as Tab-seperated values</dt>
    <dd><tt>/</tt></dd>
    <dd><tt>/index.txt</tt></dd>
    <dd><tt>/index.tsv</tt></dd>

  <dt>Comma-seperated values</dt>
    <dd><tt>/index.csv</tt></dd>

  <dt>Yaml hash</dt>
    <dd><tt>/index.yaml</tt></dd>
    <dd><tt>/index.yml</tt></dd>

  <dt>JSON hash</dt>
    <dd><tt>/index.json</tt></dd>
</dl>

## License
**Facts, The Application** is licensed under the MIT license. Hack away!

## Installation

**Facts, The Application** is a drop-in Sinatra application, and is suitable for any Rack-compatible web server. I've used it with Passenger and Unicorn, but preliminary tests with Puma and Thin showed that the server doesn't really matter here; it's a super simple application.

## Configuration

Like Facter itself, **Facts, The Application** can load any facts provided by Puppet modules. Start Facts, The Application with the environment variable `USE_PUPPET` set to anything (ANYTHING but `false` which might go awry) and watch it load up them delicious Module facts.

## Requirements
* Ruby (1.9.2 or greater)
* Facter
* Sinatra
* multi-json
* Puppet, if you want to use facts distributed by Puppet

While **Facts, The Application** was developed against Facter 1.7.0, Ruby 1.9.3, and Puppet 3.3.0, Facts has been tested against Ruby 2.1.5, Facter 2.3.0, and Puppet 3.7.3 so I'm mostly confident that it should work for you.
