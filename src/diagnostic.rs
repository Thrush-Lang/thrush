use {
    super::{error::{ThrushError, ThrushErrorKind}, FILE_NAME_WITH_EXT},
    colored::Colorize,
    std::{fs::File, io::{BufRead, BufReader} }
};

pub struct Diagnostic {
    buffer: String,
    drawer: String,
    lines: Vec<String>
}

impl Diagnostic {
    pub fn new(path: String) -> Self {

        let file: File = File::open(path).unwrap();
        let lines: Vec<String> = BufReader::new(file).lines().map(|line| {
            line.unwrap().to_string()
        }).collect();

        Self {
            buffer: String::new(),
            drawer: String::new(),
            lines
        }
    }

    pub fn report(&mut self, error: ThrushError) {
        match error {
            ThrushError::Parse(ThrushErrorKind::ParsedNumber | ThrushErrorKind::UnreachableNumber | ThrushErrorKind::SyntaxError | ThrushErrorKind::UnreachableVariable | ThrushErrorKind::VariableNotDefined, title, help, span, line) => {
                self.print_report( title, help, span, line);
            },

            ThrushError::Lex(ThrushErrorKind::SyntaxError | ThrushErrorKind::ParsedNumber | ThrushErrorKind::UnreachableNumber | ThrushErrorKind::UnknownChar,  title, help, span, line) => {
                self.print_report(title, help, span, line);
            },

            _ => {}
        }
    }

    fn print_report(&mut self, title: String, help: String, span: (usize, usize), line: usize) {
        self.print_header(span, line, title);

        let line: &str = if line == self.lines.len() - 1 {
            self.lines.last().unwrap().trim()
        } else {
            self.lines[line - 1].trim()
        };

        self.buffer.push_str("  ");
        self.buffer.push_str(&format!("{}\n", line));


        for _ in 0..line.len() + 4 {
            self.drawer
                .push_str("^".bold().bright_red().to_string().as_str());
        }

        self.buffer.push_str(&self.drawer);

        println!("{}", self.buffer);

        self.drawer.clear();
        self.buffer.clear();

        println!(
            "\n{}{} {}\n",
            "Help".bold().bright_green(),
            ":".bold(),
            help.bold()
        );
    }

    fn print_header(&mut self, span: (usize, usize), line: usize, title: String) {
        println!(
            "\n{} {}{}{}\n",
            FILE_NAME_WITH_EXT.lock().unwrap().bold().bright_red(),
            line,
            ":".bold(),
            format!("{}..{}", span.0, span.1).bold()
        );

        println!(
            "{} {}\n",
            "ERROR:".bold().bright_red().underline(),
            title.bold()
        );
    }

}
