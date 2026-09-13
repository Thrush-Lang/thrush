<img src= "https://github.com/thrustlang/.github/blob/main/assets/logos/new%20logo/thrustlang-logo-banner-text-italic.png" alt= "logo" style= "width: 80%; height: 80%;"></img>

# The Thrust Compiler 

<img src="https://github.com/thrustlang/.github/blob/main/assets/standard-text-separator.png" alt="standard-separator" style="width: 1hv;">

This is an example of the type of compiler diagnostics you can find in thrustc:

These can be displayed in color using `--enable-ansi-color`, which is off by default.

For example:

### Errors

#### Type Mismatch

<img src= "https://github.com/thrustlang/thrustc/blob/master/assets/examples/diagnostics/TypeMismatchDiagnostic.png"></img>

#### Value Without Address

<img src= "https://github.com/thrustlang/thrustc/blob/master/assets/examples/diagnostics/ValueWithoutAddressDiagnostic.png"></img>

### Warnings

#### Unknown Call Convention

<img src= "https://github.com/thrustlang/thrustc/blob/master/assets/examples/diagnostics/UnknownCallConventionWarningDiagnostic.png"></img>

#### Attribute Conflict

<img src= "https://github.com/thrustlang/thrustc/blob/master/assets/examples/diagnostics/AttributeConflictWarningDiagnostic.png"></img>

These are some examples of diagnostics that you can find in Thrust and that will be useful when using the language.

You can understand a diagnostic better using `thrustc --explain W0004` or `thrustc --explain E0007`, which explains in detail why the issue exists in the code when an explanation is available.
