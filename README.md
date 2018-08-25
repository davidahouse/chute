# About chute

Chute is a development tool that collects data about your project, compares that data against previous executions and then creates reports and notifications based on the details collected. The ultimate goal of `chute` is to provide a tool that can be executed by CI against pull requests to report on what impact a code change has made on the unit tests, code coverage, screenshots, visual styles, lines of code, code complexity and more. Providing rich, yet easy to digest information about a code change helps to increase code quality by improving the code review process.

Chute can capture the following information from a project:

- Test execution status
- Test execution collected screenshots (Xcode 9 new feature!)
- Test execution metadata capture (colors & fonts for example)
- Code coverage details
- More to come!

Chute is designed to run after you have executed your test suite in `Xcode` or `xcodebuild`. It scans the derived data folder for the most recent test execution for your project and uses that data as the primary source for reporting.

Chute reports are available in HTML, and can also be saved for later review or for use in comparing test executions. Chute captures Attachments and presents them alongside the test status, making review of captured screenshots easy and quick.

Chute also generates a style sheet from the captured views (using a XCTestCase extension you need to use in your tests) and will give you a list of all the colors & fonts that your application is using. This data is also available for comparison.

# Example reports

[View An Example Report](http://davidahouse.com/chute/sample_report/chute.html)

[View An Example Difference Report](http://davidahouse.com/chute/sample_difference_report/chute_difference.html)

# Getting started

Download the latest release and place the resulting binary in `/usr/local/bin`, or grab the latest source code and compile the binary.

Execute your test suite and in the same folder as the Xcode project, execute the basic chute command: `chute -project <project>`. You will find the report outputs in a folder named `chute_output`. `chute.html` contains the summary of the test execution and links to the more detailed reports captured.

# Creating a difference report

To create a difference report you must first save the results of the `chute_output` folder and place in a different location (if you keep it in the project folder it will get overwritten). Then just execute `chute` in your current project folder with an added command line option `-compareFolder <folder>`, using the saved location above. `chute` will create both full report in a `chute.html` file, and the difference between the current project details and the saved details in a `chute_difference.html` file.

# Capturing screenshots and style sheet information

Capturing screenshots is done in your `XCTestCase` test methods and is done by creating an instance of `XCTestAttachment` and calling the `add` method of `XCTestCase`. Setting the `name` property is useful so that `chute` can include that in the report, and set the `lifetime` to `.keepAlways` so the attachment stays after the test execution.

A helper class is included in `chute` and can be found in the `ChuteExample/ChuteExampleTests/Chute/ChuteTestExtensions` file. This file adds an extension on `XCTestCase` for capturing screenshots as well as style sheet information.

Use `attachScreenshot(using:title:)` to capture any `UIView` as a screenshot.

Use `captureStyleSheetInfo(using:title:)` to capture the style sheet information for a `UIView` and its `subviews`.

Use `chuteCaptureViewController(viewController:title:)` to capture the screenshot and style sheet information for a view controller. It is a convenience for the above two methods.

# Publishing chute reports to github pages

Chute can publish reports to a repositories github pages branch, then use that link when generating github or slack notifications.

|   |   |
|---|---|
| -githubRepository <repository> | Repository should be in the format <username>/<repository>. For example: davidahouse/ChuteExample |
| -githubToken <token> | Personal access token [Github doc](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) |
| -githubPagesFolder <folder> | The folder in github pages to use as a root for the chute generated reports. Chute will generate a sub-folder under this root for each test execution date found. |
| -publishRootURL <url> | The URL to use as a base for the links in notifications. For github pages publishing, this root url can be found in the settings page of the repository. |

# Generating github PR comments

To create comments on a github pull request, just set the following parameters on the `chute` command line:

|   |   |
|---|---|
| -githubRepository <repository> | Repository should be in the format <username>/<repository>. For example: davidahouse/ChuteExample |
| -githubToken <token> | Personal access token [Github doc](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) |
| -pullRequestNumber <number> | The pull request number to comment on |

The github comment contains a summary of the chute execution.

# Generating slack notification

|   |   |
|---|---|
| -slackWebhook <webhook> | Slack integration webhook |

# Roadmap

- [X] Basic chute implementation that generates HTML reports
- [X] Implement saving of chute data capture for use in compares
- [X] Implement comparison between saved capture and current capture
- [X] Remove `xcov` dependency for code coverage stats
- [X] Separate screenshots into their own report and show screens in a more easily digested format
- [X] Allow chute to update Pull Request with capture summary & link for full reports using github pages
- [X] Allow chute to use github pages saved data as source of comparison
- [ ] Improved helper library for capturing view controllers, views and windows
- [ ] Make chute more generic by creating a plugin system that allows others to easily create new report types
- [ ] Capture non-test related data such as lines of code, project settings, etc.
- [ ] Support Android testing and view capture
- [ ] Brew formula to make install easier

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
