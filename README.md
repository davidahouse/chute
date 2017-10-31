# About chute

Unit test visualization in Xcode is functional, but can be improved. Chute was created to augment this functionality in the following ways:

- HTML report of test status and code coverage details
- Inline visualization of test attachments (screen shots, strings, etc)
- Comparison between test execution runs (particularly for comparing pull request changes)
- Capture and visualization of colors and fonts used in the application

The ultimate goal of `chute` is to provide a tool that can be executed by CI against pull requests to report on what impact a code change has made on the unit tests, code coverage, screenshots and styles. Imagine knowing exactly which screens were changed by a PR and what the screens look like, without having to run the application!

Chute uses new capabilities in Xcode 9, in particular `XCTestAttachment` to collect screenshots and style information.

Chute is designed to run after you have executed your test suite in `Xcode` or `xcodebuild`. Chute then gathers the following information and creates reports from them:

- Test status
- Code coverage
- Attachments (XCTAttachment ftw!)
- Style sheet

Chute reports are available in HTML, and can also be saved for later review or for use in comparing test executions. Chute captures Attachments and presents them alongside the test status, making review of captured screenshots easy and quick. Other attachments can also be reviewed inline including strings and other custom data.

Chute also generates a style sheet from the captured views (using a XCTestCase extension you need to use in your tests) and will give you a list of all the colors & fonts that your application is using. This data is also available for comparison.

Saving the chute reports and comparing them later is a perfect addition to your CI process for pull requests. Now the pull request can display a list of all the test differences, code coverage changes as well as screenshots that have changed or style sheet changes.

[View An Example Report](http://davidahouse.com/chute/sample_report/chute.html)

[View An Example Difference Report](http://davidahouse.com/chute/sample_difference_report/chute_difference.html)

# Getting started

Clone this repository and compile `chute`. Place the resulting binary in `/usr/local/bin`. In the future we will add a `brew` formula to make this step easier.

Execute your test suite and in the same folder as the Xcode project, execute the basic chute command: `chute -project <project>`. You will find the report outputs in a folder named `chute_output`. `chute.html` contains the summary of the test execution and links to the more detailed reports captured.

Note that currently `chute` needs the result of `xcov` to capture the code coverage report for your tests. Just execute the following command to create the json output needed before running the above `chute` command: `xcov -project <project> -scheme <scheme> --json_report`.

# Creating a difference report

To create a difference report you must first save the results of the `chute_output` folder and place in a different location (if you keep it in the project folder it will get overwritten). Then just execute `chute` in your current project folder with an added command line option `-compareFolder <folder>`, using the saved location above. `chute` will create both full report in a `chute.html` file, and the difference between the current project details and the saved details in a `chute_difference.html` file.

# Capturing screenshots and style sheet information

Capturing screenshots is done in your `XCTestCase` test method and is done by creating an instance of `XCTestAttachment` and calling the `add` method of `XCTestCase`. Setting the `name` property is useful so that `chute` can include that in the report, and set the `lifetime` to `.keepAlways` so the attachment stays after the test execution.

A helper class is included in `chute` and can be found in the `ChuteExample/ChuteExampleTests/Chute/ChuteTestExtensions` file. This file adds an extension on `XCTestCase` for capturing screenshots as well as style sheet information.

Use `attachScreenshot(using:title:)` to capture any `UIView` as a screenshot.

Use `captureStyleSheetInfo(using:title:)` to capture the style sheet information for a `UIView` and its `subviews`.

Use `chuteCaptureViewController(viewController:title:)` to capture the screenshot and style sheet information for a view controller. It is a convenience for the above two methods.

# Roadmap

- [X] Basic chute implementation that generates HTML reports
- [X] Implement saving of chute data capture for use in compares
- [X] Implement comparison between saved capture and current capture
- [ ] Fastlane action for executing chute easier
- [ ] Danger.systems plugin for updating Pull Request with summary
- [ ] Allow chute to update Pull Request with capture summary & link for full reports
- [ ] Automate or remove `xcov` dependency for code coverage stats
- [ ] Brew formula to make install easier
- [ ] New report types

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
