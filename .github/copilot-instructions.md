# AI Code Generation Rules

1. **Always Output Your Answers in Japanese**
   - For enhanced accuracy and depth in internal reasoning and calculations, these processes should preferably be conducted in English. However, the final answer must always be translated into Japanese.

2. **Pre-Analysis Before Code Generation**
   - Before generating any code, analyze potential security vulnerabilities and performance issues in accordance with existing security and performance rules.
   - Avoid using deprecated functions and insecure practices.

3. **Adhere to Consistent Coding Standards**
   - Generated code must follow the project's coding guidelines (indentation, naming conventions, file structure, etc.) to maintain consistency with the existing codebase.

4. **Enforce Modularity and the Single Responsibility Principle (SRP)**
   - Design functions and classes to focus on a single responsibility. Eliminate redundant or duplicate code, and extract common functionality into separate functions or modules.

5. **Generate Clear Documentation and Comments**
   - Automatically include documentation comments for each function and class, detailing usage, parameters, return values, and exception handling.
   - For complex logic, add concise inline comments that clearly explain the design intent to enhance maintainability.

6. **Manage Dependencies**
   - Keep external library and module dependencies to a minimum by avoiding unnecessary libraries.
   - Design the code with maintainability and compatibility in mind, ensuring that dependency management does not complicate future updates.

7. **Implement Input Validation and Logging**
   - Validate all inputs from users or external systems using proper type checks, format validation, and mandatory field verification.
   - Include appropriate logging (with clear distinctions among log levels such as INFO, WARN, and ERROR) in critical code sections to facilitate debugging and troubleshooting.

8. **Generate and Integrate Test Cases**
   - Where possible, automatically generate sample unit tests or integration tests for the generated code.
   - Ensure that the code is integrated with CI/CD pipelines to confirm that changes do not adversely affect other parts of the project.

9. **Track Change History and Update Documentation**
   - When modifying existing functions or modules, update all corresponding documentation, including README files and API docs.
   - Ensure that any changes to the generated code are tracked using a version control system (e.g., Git).

10. **Consider Usability and Extensibility**
   - Design the generated code to be simple, intuitive, and easy to extend for future functionality.
   - Prioritize maintainability and readability so that anyone reviewing the code can quickly understand its purpose and logic.

# Commit Message Guidelines

1. **Follow Conventional Commit Format with Japanese**
   - Use the format: `type(scope): 日本語での説明`
   - Available types: feat, fix, docs, style, refactor, test, chore
   - Example: `feat(auth): ユーザー認証システムを追加`

2. **Keep Subject Line Concise**
   - Keep the first line under 30 characters (including Japanese characters)
   - Use simple, direct expressions for the subject line
   - Use consistent verb forms in Japanese with specific patterns:
     - New features: 「〜を追加」「〜を実装」「〜を導入」
     - Fixes: 「〜を修正」「〜を解決」「〜を訂正」
     - Updates: 「〜を更新」「〜を改善」「〜を最適化」
     - Deletions: 「〜を削除」「〜を除去」

3. **Provide Detailed Context in Body**
   - Include a detailed body in Japanese for all significant changes, explaining what and why
   - Separate the subject line and body with a blank line
   - Use the body to provide context that couldn't fit in the concise subject line

4. **Use Consistent Scope Names**
   - Use clear, descriptive scope names (e.g., api, ui, db, auth)
   - Keep scope names consistent across the project
   - Scope names should remain in English for consistency
