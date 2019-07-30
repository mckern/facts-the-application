# Facts, The Application
## Display facter facts over HTTP, using Sinatra

A simple [Sinatra](http://www.sinatrarb.com/) application for exposing the data available to [Facter](http://puppetlabs.com/facter) over HTTP (or HTTPS, with an appropriate application proxy). Super handy if you don't have (or can't use) PuppetDB to store fact values for your nodes or if you want to query your nodes out-of-band or asynchronously.

## Available endpoints

<dl>
  <dt>Display facts as a JSON hash</dt>
    <dd><tt>/</tt></dd>
    <dd><tt>/index.json</tt></dd>

  <dt>or as a Yaml hash</dt>
    <dd><tt>/index.yaml</tt></dd>
    <dd><tt>/index.yml</tt></dd>
</dl>

If you're using pure Ruby facter, which doesn't support structured facts,
then the following endpoints are also available:

<dl>
  <dt>Display facts as Tab-seperated values</dt>
    <dd><tt>/index.txt</tt></dd>
    <dd><tt>/index.tsv</tt></dd>

  <dt>or as Comma-seperated values</dt>
    <dd><tt>/index.csv</tt></dd>
</dl>

## License
**Facts, The Application** is licensed under the MIT license. Hack away!

## Installation

**Facts, The Application** is a drop-in Sinatra application, and is suitable for any Rack-compatible web server. I've used it with Passenger and Unicorn, but preliminary tests with Puma and Thin showed that the server doesn't really matter here; it's a super simple application.

### Bootstrapping

Bundler groups have been used to keep the requirement path short. To install runtime dependencies, run:

```
$ bundle install --path=.bundle/gems --without facter puppet test development
```

### Running "Facts, The Application"

By default, **Facts, The Application** supports [Puma](https://github.com/puma/puma). To run **Facts, The Application** with Puma, simply run:

```
$ bundle exec puma --bind tcp://127.0.0.1:9090
```

**Facts, The Application** does not support application environments

## Puppet-distributed Facts

### These may be broken if you're using the Puppet Agent

Like Facter itself, **Facts, The Application** can load any facts provided by Puppet modules. Start **Facts, The Application** with the environment variable `USE_PUPPET` set to anything (ANYTHING but `false` which might go awry) and watch it load up them delicious Module facts.

## Native Facter or Ruby Facter?

Start **Facts, The Application** with the environment variable `SLOW_FACTER_PLEASE` set to anything (again, try to avoid the value `false` because we're not filtering for it) and **Facts, The Application** will positively *demand* that you install Facter from a gem instead of using the vendored native library functionality.

Additionally, Native Facter will respect the value of the `FACTERDIR` environment variable if you need to point at a specific instance of Native Facter -- by default, it expects to find a shared Facter library (`libfacter.so`) under `/usr/lib`.

## Requirements
* Ruby (1.9.2 or greater; but 2.2.x or better is a _much_ better bet)
* Facter (Native or "classic" -- Native Facter will make your life a little better)
* Sinatra >= 2.0.0
* Puppet (if you want to use facts distributed by Puppet)

While **Facts, The Application** was originally developed against Facter 1.7.0, Ruby 1.9.3, and Puppet 3.3.0, Facts has been tested against Ruby 2.6.0, Facter 3.13.1, and Puppet 6.4.0 so I'm mostly confident that it should work for you.

### Support & contribution?

In the spirit of Jordan Sissel (a hero to admins and operations people everywhere), if **Facts, The Application** is not helping you get Facter data over HTTP, then there is a bug in **Facts, The Application**. Please open an issue or submit a pull request if something doesn't work.
