use super::frontend::lexer::TokenSpan;

#[derive(Default, Debug)]
pub enum ThrushError {
    Compile(String),
    Parse(ThrushErrorKind, String, String, TokenSpan, usize),
    Lex(ThrushErrorKind, String, String, TokenSpan, usize),
    Scope(ThrushErrorKind, String, String, TokenSpan, usize),
    #[default]
    None,
}

#[derive(Debug)]
pub enum ThrushErrorKind {
    TooManyArguments,
    SyntaxError,
    UnreachableNumber,
    ParsedNumber,
    UnknownChar,
    UnreachableVariable,
    VariableNotDefined,
}
