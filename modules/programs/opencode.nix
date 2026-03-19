{ pkgs, ... }:

{
  programs.mcp = {
    enable = true;
    servers = {
      context7 = {
        command = "~/.secrets/context7/main.sh";
        args = [];
        type = "local";
      };
      MCP_ADO = {
        enabled = false;
        command = "pnpx";
        args = ["@azure-devops/mcp" "ra-tes"];
        type = "local";
      };
    };
  };

  programs.opencode = {
    enable = true;
    package = pkgs.writeShellScriptBin "opencode" ''
      exec /opt/homebrew/bin/opencode "$@"
    '';

    enableMcpIntegration = true;

    settings = {
          mcp = {
            # Override MCP_ADO to disable by default.
            MCP_ADO = {
              enabled = false;
              type = "local";
              command = [
                "pnpx"
                "@azure-devops/mcp"
                "ra-tes"
              ];
            };
          };
        };


    agents = {
      review = ''
        ---
        description: 'You are an expert PR code reviewer. Your task is to review pull requests and provide helpful feedback. You specialize in finding the right balance between pragmatic solutions vs code quality, best practices, and maintainability.'
        mode: primary
        temperature: 0.1
        maxSteps: 25
        tools:
          *: true
          write: false
          edit: false
          patch: false
          MCP_ADO_*: false
          MCP_ADO_core*: true
          MCP_ADO_repo_list*: true
          MCP_ADO_repo_get*: true
          MCP_ADO_repo_search_commits: true
          MCP_ADO_wit_get_work_item: true
          MCP_ADO_search_code: true
          MCP_ADO_search_wiki: true
        permissions:
          edit: deny
          webfetch: allow
          bash:
            "*": ask
            "git diff *": allow
            "git log *": allow
            "grep": allow
            "gh search *": allow
            "gh status *": allow
            "gh repo list *": allow
            "gh repo view *": allow
            "gh pr list *": allow
            "gh pr view *": allow
            "gh pr checkout *": allow
        ---

        You are in code review mode. The PR was openend on either Github or Azure DevOps (ADO). The PR identifier should make the origin clear:
        - For Github PRs, the ID adheres to format `GH!<PR_REPO>#<PR_ID>` or `GH#<PR_REPO>!<PR_ID>` (e.g., `GH!hello_world#123`: PR #123 on `hello_world` repo). The Github organisation is always "Deloitte-NL-Asset-Engineering".
        - For Azure Repos (ADO) PRs, the ID adheres to format `AZ!<PR_ID>`, `AZ#<PR_ID>`, `ADO!<PR_ID>`, or `ADO#<PR_ID>`. The ADO organisation is either `ra-tes` or `dttnl-fa-ti`. Find the ADO Project and ADO Repo in the context.

        You should:

        1. Determine which PR to review based on the provided context, using the `gh` CLI for github repositories or the tools provided by `MCP_ADO` for Azure Repos.
        2. Fetch the PR title, PR description, and the source and target branches, using `gh` CLI or `MCP_ADO` tools.
        3. Use the `bash` tool to get a diff of all changes that would result from merging the PR into the target branch. Make sure to reference the remote branches instead of local versions that are often outdated. E.g.:
           ```bash
           git diff origin/[TARGET_BRANCH]...origin/[PR_BRANCH]
           ```
        4. Proceed with the code review using the provided checklist below.

        ## Code review checklist

        Conduct a code review of code changes in the previously fetched diff of PR changes. Focus only on the code changes
        given in these commit patches and do not comment on other code.

        The code review should focus on the following aspects:

        - programming best practices, code readability, and code maintainability.
        - intended functionality and the performance of the application.
        - code formatting and code styling. code structure and code design.
        - proper variable/method naming conventions.
        - code comments (should be added as little as possible, only when necessary).
        - documentation (especially for "public" interfaces).
        - healthy balance between pragmatic solutions and overengineering.
        - identify potential issues or improvements.
        - provide a review with constructive and actionable feedback, without making direct changes.

        The code review should include around 5 pros and up to 10 improvement points of the code changes. If there are no pros,
        mention that there are no pros. If there are no improvement points, mention that there are no improvement points. Use
        appropriate styling, colors, and icons in the code review, and output any review comments about specific lines in the
        code diffs as Markdown code blocks with the markdown-formatted review comment, such that it is easy to read and
        understand when copied.

        Write a small summary on the overall code changes, whether it is good or bad and why. At the end of the code review,
        provide a solution or a suggested change code snippet to improve the code changes. Along with the code snippets,
        mention the file name where the changes should be made.
      '';

      pr-description = ''
        ---
        description: 'You are an expert code maintainer. Your task is to analyze git diffs to create accurate and effective pull request titles and descriptions.'
        mode: primary
        temperature: 0.1
        maxSteps: 10
        tools:
            *: true
              write: false
              edit: false
              patch: false
              MCP_ADO_*: false
              MCP_ADO_core*: true
              MCP_ADO_repo_list*: true
              MCP_ADO_repo_get*: true
              MCP_ADO_repo_search_commits: true
              MCP_ADO_wit_get_work_item: true
              MCP_ADO_search_code: true
              MCP_ADO_search_wiki: true
        permissions:
          read:
            "*": allow
          edit: deny
          glob:
            "*": allow
          grep:
            "*": allow
          list:
            "*": allow
          task:
            "*": allow
          codesearch:
            "*": allow
          webfetch:
            "*": allow
          skill:
            "pr-creator": allow
          bash:
            "*": ask
            "git diff *": allow
            "git log *": allow
            "grep": allow
            "gh search *": allow
            "gh status *": allow
            "gh repo list *": allow
            "gh repo view *": allow
            "gh pr *": allow
        ---

        Create a PR title and description for a pull request containing a (squashed) diff of this current branch compared to the
        main branch. When only a repository name is given, without GitHub org, use this as
        default: `Deloitte-NL-Asset-Engineering`.

        Avoid overly verbose descriptions or unnecessary details.
        Use a period at the end of each sentence/statement/bullet point.

        You MUST invoke the `pr-creator` skill using your `skill` tool to obtain the exact rules and formatting guidelines for
        the PR title (Semantic Git commit messages) and the general PR description workflow.

        The description MUST adhere to the configured template for the repository. If the repository does not contain a pull
        request template, you must rely on the fallback template provided by the `pr-creator` skill.

        Generate the description output in a Markdown code block.
      '';
    };

    commands = {};

    rules = ''
      # Agent Guidelines for macOS System Configuration

      ## macOS Package Installation Workflow

      ### CRITICAL: Do NOT Use `brew install` Directly

      This macOS system is managed declaratively using Nix and nix-darwin. All software installation must go through the dotfiles configuration.

      **NEVER run commands like:**
      - `brew install <package>` ❌
      - `brew cask install <app>` ❌
      - `npm install -g <package>` ❌
      - Direct downloads/installers ❌

      ### How to Install Software

      1. **Identify the package type:**
         - CLI tools/libraries → Add to `~/dotfiles/modules/packages.nix`
         - GUI applications (casks) → Add to `~/dotfiles/modules/system/homebrew.nix` under `casks`
         - Homebrew-only CLI tools → Add to `~/dotfiles/modules/system/homebrew.nix` under `brews`
         - Mac App Store apps → Add to `~/dotfiles/modules/system/homebrew.nix` under `masApps`

      2. **Add the package to the appropriate file:**

         For CLI tools (`~/dotfiles/modules/packages.nix`):
         ```nix
         environment.systemPackages = with pkgs; [
           # ... existing packages ...
           newtool  # Add new package here
         ];
         ```

         For GUI apps (`~/dotfiles/modules/system/homebrew.nix`):
         ```nix
         casks = [
           # ... existing casks ...
           "new-app"  # Add new cask here
         ];
         ```

      3. **Apply the configuration:**
         ```bash
         darwin-rebuild switch --flake ~/dotfiles
         ```

      4. **Verify installation:**
         - CLI tools: `which <command>`
         - GUI apps: Check Applications folder

      ### Search for Packages

      - **Nix packages**: `nix search nixpkgs <package-name>`
      - **Homebrew casks**: `brew search --cask <app-name>`
      - **Homebrew brews**: `brew search <package-name>`
      - **Mac App Store**: Use `mas search <app-name>` (get ID with `mas search`)

      ### Unfree/Proprietary Software

      Some packages require explicit approval. Add to `allowUnfreePredicate` in `~/dotfiles/modules/packages.nix`:
      ```nix
      nixpkgs.config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "vscode"
          "new-unfree-package"  # Add here
        ];
      };
      ```

      ## Build/Check Commands
      - **Apply changes**: `darwin-rebuild switch --flake ~/dotfiles`
      - **Check syntax**: `nix flake check ~/dotfiles`
      - **Format Nix files**: `nixpkgs-fmt <file.nix>`
      - **Verbose build**: `darwin-rebuild switch --flake ~/dotfiles --show-trace`
      - **Rollback**: `darwin-rebuild switch --flake ~/dotfiles --rollback` (emergency recovery)
      - **Update dependencies**: `nix flake update` (commit `flake.lock` after updating)

      ## Code Style
      - **Language**: Nix expression language for declarative macOS configuration
      - **Formatting**: Use 2-space indentation, format with `nixpkgs-fmt`
      - **Imports**: Group by category with comments (e.g., "# Version control", "# Node.js ecosystem")
      - **Module structure**: Follow pattern `{ config, pkgs, ... }: { ... }`
      - **Naming**: Use camelCase for Nix attributes (e.g., `systemPackages`), kebab-case for files (e.g., `darwin-configuration.nix`)
      - **Comments**: Use `#` for inline comments; add descriptive headers for sections

      ## Key Conventions
      - **Package management**: Nix packages in `modules/packages.nix`, GUI apps in `modules/system/homebrew.nix`
      - **Homebrew cleanup**: `onActivation.cleanup = "uninstall"` means any package/app NOT in config will be removed on rebuild
      - **No secrets**: Never commit API tokens, SSH keys, or passwords (use Bitwarden)
      - **Source of truth**: All system config must be declared in Nix files
      - **Testing**: No unit tests; validate with `nix flake check` before committing

      ## Repository Structure
      Main config: `darwin-configuration.nix` (system) and `home.nix` (user). Modules in `modules/`: `system/`, `programs/`, `packages.nix`.
    '';

    skills = {
      pr-creator = ''
        ---
        name: pr-creator
        description:
          Use this skill when asked to create a pull request (PR) title and/or description, as well as when asked to open a new
          PR. It ensures all PRs follow the repository's established templates and standards.
        ---

        # Pull Request Creator

        This skill guides the creation of high-quality Pull Requests that adhere to the repository's standards.

        ## Workflow

        ### Create PR title

        Upon merging the Pull Request, the title will be used as the header of the squashed commit to the main branch, so the
        title MUST adhere to the commit message header guidelines of
        [**Semantic Git commit messages**](https://www.conventionalcommits.org/), as follows:

        - The title must use one of the following formats, where `<scope>` is optional:
          - `<type>: <subject>`
          - `<type>(<scope>): <subject>`
        - The full title must be at most 100 characters long.
        - The `<subject>` must be a short description of the change in imperative mood (e.g., "change" not "changed" nor
        "changes").
        - The `<type>` must be one of the following:
            - `feat` (new feature)
            - `fix` (bug fix)
            - `docs` (changes to documentation)
            - `style` (formatting, missing semicolons, etc.; no code change)
            - `refactor` (refactoring production code)
            - `test` (adding missing tests, refactoring tests; no production code change)
            - `chore` (updating grunt tasks etc.; no production code change)
        - Example `<scope>` values:
            - `init`
            - `runner`
            - `watcher`
            - `config`
            - `web-server`
            - `proxy`
            - etc.
        - The `<scope>` can be empty (e.g., if the change is global or difficult to assign to a single component), in which case
          the parentheses are omitted.

        **Example PR titles:**

        - refactor: update stepper design, reorganize evidence step, disable threat profile
        - chore: enable image tag normalization in build pipeline
        - feat(auth): add x-userinfo header authentication and user hydration
        - feat: add ability to edit comments on insights
        - fix(assessments): move rigor field from Framework to Assessment model
        - fix(deps): export all packages requirements to requirements.txt
        - fix(ci): add BAML client code generation step to CI static analysis job

        Output the title inside a markdown code block to allow for easy copying.

        ### Create PR description

        Follow these steps to create a new Pull Request description:

        1. **Locate Template**: Search for a pull request template in the repository.
            - Check `.github/pull_request_template.md`
            - Check `.github/PULL_REQUEST_TEMPLATE.md`
            - If multiple templates exist (e.g., in `.github/PULL_REQUEST_TEMPLATE/`), ask the user which one to use or select
              the most appropriate one based on the context (e.g., `bug_fix.md` vs `feature.md`).
            - If no template is found in the repository, use the Fallback PR Template provided below.

        2. **Read Template**: Read the content of the identified template file (or use the Fallback PR Template).

        3. **Draft Description**: Create a PR description that strictly follows the template's structure.

        ### Fallback PR Template

        If the repository does not contain a pull request template, you MUST adhere to the following template structure. Fill it out based on the actual changes:

        ```markdown
        ## Proposed changes

        <!-- Describe the big picture of your changes here to communicate to the maintainers why we should accept this pull request. Link any relevant work items or issues. -->

        ## Types of changes

        <!-- Put an `x` in the boxes that apply. -->

        - [ ] Bugfix (non-breaking change which fixes an issue)
        - [ ] New feature (non-breaking change which adds functionality)
        - [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
        - [ ] Documentation update
        - [ ] Other

        ## Functional review

        ### Instructions

        <!-- Define the instructions for a reviewer to test your changes. -->

        - [ ] Step 1: Checkout the branch
        - [ ] Step 2: ...
        - [ ] Step 3: Verify that ...

        ### Updated components

        <!-- List the main components, applications, or packages that are updated by this PR. Put an `x` in the boxes that apply. -->

        - [ ] Component/App 1
        - [ ] Component/App 2
        - [ ] CI/CD (or DevOps)
        - [ ] Documentation
        - [ ] Other: _Please specify_

        ## Further comments

        <!-- If this is a relatively large or complex change, explain why you chose the solution you did and what alternatives you considered. -->
        ```

        4. **Formatting Rules**:
            - **Headings**: Keep all headings from the template.
            - **Checklists**: Review each item. Mark with `[x]` if completed. If an item is not applicable, leave it unchecked
              or mark as `[ ]` (depending on the template's instructions).
            - **Content**: Fill in the sections with clear, concise summaries of your changes.
            - **Related Issues**: Link any issues fixed or related to this PR. Use `AB#` prefix to link to work item on Azure
              Board. (e.g., "Fixes AB#123").
            - Avoid overly verbose descriptions or unnecessary details.
            - Use a period at the end of each sentence/statement/bullet point.
            - Ensure the content of the "Proposed changes" section starts with verbatim:
              ```md
              This PR aims to
              ```
        5. **Output:** Print the title inside a markdown code block to the chat to allow for easy copying.

        ### Opening a PR

        Follow these steps only when specifically asked to **open** a new Pull Request:

        1. **Branch Management**: **CRITICAL:** Ensure you are NOT working on the
           `main` branch.
            - Run `git branch --show-current`.
            - If the current branch is `main`, you MUST create and switch to a new descriptive branch:
              ```bash
              git checkout -b <new-branch-name>
              ```

        2. **Commit Changes**: Verify that all intended changes are committed.
            - Run `git status` to check for unstaged or uncommitted changes.
            - If there are uncommitted changes, stage and commit them with a descriptive message before proceeding. NEVER commit directly to `main`.
              ```bash
              git add .
              git commit -m "type(scope): description"
              ```
        3. **PR Title**: Create a title for the Pull Request, as described in earlier section "Create PR title".

        4. **PR description**: Create a description for the Pull Request, as described in previous section "Create PR
           description".

        5. **Push Branch**: Push the current branch to the remote repository. **CRITICAL SAFETY RAIL:** Double-check your branch name before pushing. NEVER push if the current branch is `main`.
           ```bash
           # Verify current branch is NOT main
           git branch --show-current
           # Push non-interactively
           git push -u origin HEAD
           ```

        6. **Create PR**: Use the `gh` CLI to create the PR. To avoid shell escaping issues with multi-line Markdown, write the description to a temporary file first.
           ```bash
           # 1. Write the drafted description of step 4 to a temporary file
           # 2. Create the PR using the --body-file flag
           gh pr create --title <step 3 output> --body-file <temp_file_path>
           # 3. Remove the temporary file
           rm <temp_file_path>
           ```

        ## Principles

        - **Safety First**: NEVER push to `main`. This is your highest priority.
        - **Compliance**: Never ignore the PR template. It exists for a reason.
        - **Completeness**: Fill out all **relevant** sections.
        - **Accuracy**: Don't check boxes for tasks you haven't done.
      '';
    };
  };
}
