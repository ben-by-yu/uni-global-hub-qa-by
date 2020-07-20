# Global Agent Hub Automation

## Setup environment

1) Installation following Software
    * Install IntelliJ Ultimate/Rubymine and install Ruby plugin
    * Install Ruby by running rubyinstaller-2.5.1-2
    * Install bundler by running `gem install bundler`    

2) Change directory to the repo and run
    * bundle install
    * rake cucumber # To run the feature files

## Executing Scenarios

### Using Rake command

1) *Run all features:*
    ````
        rake cucumber
    ````

2) *Run one feature:*
    ````
        bundle exec cucumber <path>

        # Example
        bundle exec cucumber features/common/user_portal.feature
    ````

    Note: To run one scenario within a feature:
    ````
        bundle exec cucumber <path>:<scenario_line_number>
    ````