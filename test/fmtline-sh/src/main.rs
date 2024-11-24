use std::io::{self, Read};

#[derive(Debug)]
enum Token {
    Command(String),
    Argument(String),
    Pipe,
}

#[derive(Debug)]
struct Command {
    name: String,
    args: Vec<String>,
}

impl Command {
    fn to_string(&self) -> String {
        let mut result = self.name.clone();
        if !self.args.is_empty() {
            result.push(' ');
            result.push_str(&self.args.join(" "));
        }
        result
    }
}

#[derive(Debug)]
struct FormatConfig {
    indent_size: usize,
    indent_char: char,
}

impl Default for FormatConfig {
    fn default() -> Self {
        Self {
            indent_size: 4,
            indent_char: ' ',
        }
    }
}

impl FormatConfig {
    fn new(indent_size: usize, indent_char: char) -> Self {
        Self {
            indent_size,
            indent_char,
        }
    }

    fn indent(&self) -> String {
        self.indent_char.to_string().repeat(self.indent_size)
    }
}

#[derive(Debug)]
struct Pipeline {
    commands: Vec<Command>,
    config: FormatConfig,
}

impl Pipeline {
    fn new(config: FormatConfig) -> Self {
        Self {
            commands: Vec::new(),
            config,
        }
    }

    fn to_string(&self) -> String {
        if self.commands.is_empty() {
            return String::new();
        }

        let indent = self.config.indent();
        let mut result = String::new();

        // 最初のコマンド
        result.push_str(&self.commands[0].to_string());

        // 2番目以降のコマンド
        for cmd in self.commands.iter().skip(1) {
            result.push_str(" | \\\n");
            result.push_str(&indent);
            result.push_str(&cmd.to_string());
        }

        result
    }
}

fn tokenize(input: &str) -> Vec<Token> {
    let mut tokens = Vec::new();
    let mut current_token = String::new();
    let mut chars = input.chars().peekable();
    let mut in_single_quote = false;
    let mut in_double_quote = false;

    while let Some(c) = chars.next() {
        match c {
            '\'' if !in_double_quote => {
                in_single_quote = !in_single_quote;
                current_token.push(c);
            }
            '"' if !in_single_quote => {
                in_double_quote = !in_double_quote;
                current_token.push(c);
            }
            '|' if !in_single_quote && !in_double_quote => {
                if !current_token.is_empty() {
                    add_token(&mut tokens, current_token);
                    current_token = String::new();
                }
                tokens.push(Token::Pipe);
            }
            ' ' if !in_single_quote && !in_double_quote => {
                if !current_token.is_empty() {
                    add_token(&mut tokens, current_token);
                    current_token = String::new();
                }
            }
            _ => {
                current_token.push(c);
            }
        }
    }

    if !current_token.is_empty() {
        add_token(&mut tokens, current_token);
    }

    tokens
}

fn add_token(tokens: &mut Vec<Token>, token: String) {
    if tokens.is_empty() || matches!(tokens.last(), Some(Token::Pipe)) {
        tokens.push(Token::Command(token));
    } else {
        tokens.push(Token::Argument(token));
    }
}

fn parse_pipeline(tokens: Vec<Token>, config: FormatConfig) -> Pipeline {
    let mut pipeline = Pipeline::new(config);
    let mut current_command = None;

    for token in tokens {
        match token {
            Token::Command(name) => {
                if let Some(cmd) = current_command {
                    pipeline.commands.push(cmd);
                }
                current_command = Some(Command {
                    name,
                    args: Vec::new(),
                });
            }
            Token::Argument(arg) => {
                if let Some(cmd) = &mut current_command {
                    cmd.args.push(arg);
                }
            }
            Token::Pipe => {
                if let Some(cmd) = current_command.take() {
                    pipeline.commands.push(cmd);
                }
            }
        }
    }

    if let Some(cmd) = current_command {
        pipeline.commands.push(cmd);
    }

    pipeline
}

fn main() -> io::Result<()> {
    let mut buffer = String::new();
    io::stdin().read_to_string(&mut buffer)?;

    // カスタムコンフィグの作成（例: タブでインデント）
    let config = FormatConfig::new(2, ' '); // 2スペースインデント

    // ASTの構築
    let tokens = tokenize(&buffer);
    let ast = parse_pipeline(tokens, config);
    println!("{}", ast.to_string());

    Ok(())
}
