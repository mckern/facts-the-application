# Facts, The Application
## Display facter facts over HTTP, using Sinatra

A simple [Sinatra](http://www.sinatrarb.com/) application for exposing the data available to [Facter](http://puppetlabs.com/facter) over HTTP (or HTTPS, with an appropriate application proxy). Super handy if you don't have (or can't use) PuppetDB to store fact values for your nodes or if you want to query your nodes out-of-band or asynchronously.

## Available endpoints

<dl>
  <dt>Display facts as Tab-seperated values</dt>
    <dd><tt>/</tt></dd>
    <dd><tt>/index.txt</tt></dd>
    <dd><tt>/index.tsv</tt></dd>

  <dt>or as Comma-seperated values</dt>
    <dd><tt>/index.csv</tt></dd>

  <dt>or as a Yaml hash</dt>
    <dd><tt>/index.yaml</tt></dd>
    <dd><tt>/index.yml</tt></dd>

  <dt>or as a JSON hash</dt>
    <dd><tt>/index.json</tt></dd>
</dl>

## License
**Facts, The Application** is licensed under the MIT license. Hack away!

## Installation

**Facts, The Application** is a drop-in Sinatra application, and is suitable for any Rack-compatible web server. I've used it with Passenger and Unicorn, but preliminary tests with Puma and Thin showed that the server doesn't really matter here; it's a super simple application.

## Puppet-distributed Facts

Like Facter itself, **Facts, The Application** can load any facts provided by Puppet modules. Start **Facts, The Application** with the environment variable `USE_PUPPET` set to anything (ANYTHING but `false` which might go awry) and watch it load up them delicious Module facts.

## Native Facter?
Start **Facts, The Application** with the environment variable `SLOW_FACTER_PLEASE` set to anything (again, try to avoid the value `false` because we're not filtering for it) and **Facts, The Application** will positively *demand* that you install Facter from a gem instead of using the vendored native library functionality.

Additionally, Native Facter will respect the value of the `FACTERDIR` environment variable if you need to point at a specific instance of Native Facter -- by default, it expects to find a shared Facter library (`libfacter.so`) under `/usr/lib`.

## Requirements
* Ruby (1.9.2 or greater; but 2.1.x or better is a better bet)
* Facter (Native or "classic". Native Facter will make your life a little better)
* Sinatra
* multi-json (for pretty-printing of JSON-formatted facts)
* Puppet (if you want to use facts distributed by Puppet)

While **Facts, The Application** was developed against Facter 1.7.0, Ruby 1.9.3, and Puppet 3.3.0, Facts has been tested against Ruby 2.1.6, Facter 3.0.2, and Puppet 4.2.0 so I'm mostly confident that it should work for you.
