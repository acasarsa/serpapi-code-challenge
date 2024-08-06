# Extract Van Gogh Paintings Code Challenge

## Project Overview 🪴

This Ruby-based application is developed to extract specific information from a Google Scrolling Carousel embedded within an HTML file. It aims to collect the following details:

- the painting's title,
- an array of extensions ( the date the painting was created ),
- encoded thumbnail data, and
- the associated Google search link.

The gathered information is compiled into a JSON array and exported for convenient use.

## Technology Stack 💻

- **Ruby**: Core programming language
- **Nokogiri**: HTML parsing
- **Watir**: Headless browser functionality
- **RSpec**: Testing framework
- **MiniMagick & Base64**: Comparing encoded images with expected data

## Features 🚀

- **Precise Extraction:** Accurately extracts painting names, dates, encoded thumbnail data, and Google search links.
- **Handles Edge Cases:** Manages placeholders and non-visible images gracefully.
- **Adaptable:** Able to extract data for various HTML file structures that use Google's scrolling carousel.
- **Flexible Output:** Exports extracted data as a convenient JSON array. Gives the option to only extract specific indexes by passing an index array to the `extract` method
- **Demo & Development Tools:** Includes scripts for easy experimentation and setup (bin/demo, bin/setup, bin/console).

## Install 📥

### Clone the repository

#### Cloning from forked branch

```bash
git clone git@github.com:acasarsa/serpapi-code-challenge.git
cd serpapi-code-challenge
git checkout andrew-casarsa-code-challenge-solution-v1
```

### Set bin permissions

There are several automated bin scripts to help help with install, demoing and running the program. \
To ensure that bin directory scripts are executable s permissions using the following command:

```shell
chmod +x bin/*
```

### Install dependencies

use convenient `bin/bash` command to install dependencies or `bundle install`

```bash
bin/setup
```

## Run Tests 🧪

Run tests to see that all pass

```shell
bundle exec rspec
```

## Usage 🛠️

### Basic Extraction

This will generate an `output_data.json` file with the extracted data. Run it with the default file_path or get the `relative_path` for `salvador-dali-paintings.html` and run it with that.

```bash
bin/run
bin/run spec/fixtures/salvador-dali-paintings.html
```

### Demo / Playground

This will bring you to a `pry` session with an initialized extractor and parser ready to go. There are two sessions so you can exit into the 2nd one to try it out with a different html file. There are included helpers that will allow you to compare the encoded image data as well. See `self.demo` [`google_carousel_extractor.rb`](./lib/google_carousel_extractor.rb).

```bash
bin/demo
```

### Console

To open a console with project-specific settings, use:

```bash
bin/console
```

## Project Components

### Extractor

The core logic for extracting artwork information from the HTML file is in the CarouselExtractor class. It processes the parsed data and extracts details like name, link, date, and image thumbnail into an array of hashes.

## Parser

The HtmlFileParser class uses Nokogiri and Watir to parse the HTML content of the file. It utilizes a headless browser to fetch and process the HTML.

## Browser Service

The BrowserService class sets up a headless browser instance using Watir, which is used by the parser to fetch HTML content.

## Bin Scripts

```bash
bin/console: Opens a console for debugging and interaction.
bin/run: Runs the extractor with a default or specified HTML file.
bin/setup: Installs the necessary gems and sets up the environment.
bin/demo: Enters a Pry console with pre-instantiated extractors for demo purposes.

```

## Customization

The project can be extended to handle different types of Google Scrolling Carousels by adding more robust fallback methods and handling different edge cases as needed.

## Contributing

Feel free to submit issues or pull requests if you find any bugs or have suggestions for improvements.

## License

This project is licensed under the MIT License.
