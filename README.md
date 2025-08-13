# A Copier Template for Monarch Projects

This template uses the code-scaffolding tool [copier](https://copier.readthedocs.io/) to create  project following Monarch/BBOP standards.
Copier supports code lifecycle management, allowing you to seamlessly incorporate updates into your project when the template is enhanced.

The generated project uses [just](https://github.com/casey/just) as preferred command runner, even in the 0.1.x releases.

> The starting point of this template was [linkml-project-copier](https://github.com/linkml/linkml-project-copier/) from @dalito

## Prerequisites

The following are required and recommended tools for using this copier template and the LinkML project that it generates.
This is all one-time setup, so if you have already done it skip to the [next section](#creating-a-new-project)!
We assume that you have full internet access.

* **git / GitHub account**

  Git is the version management system with which this template and your repository are managed. The template also assumes that you
  use GitHub for hosting your project which implies that you have a GitHub account.

* **Python >= 3.10**

  LinkML tools are mainly written in Python, so you will need a recent Python interpreter to run this generator and to use the generated project.

* **uv**

  uv is a tool to manage Python projects and for managing isolated Python-based applications.
  You will use it in your generated project to manage dependencies and build distribution files.
  Install uv by following their [instructions](https://docs.astral.sh/uv/getting-started/installation/)

* **copier**

  Copier is a tool for generating projects based on a template (like this one!).
  It also allows re-configuring the projects and to keep them updated when the original template changes.
  To insert dates into the template, copier requires [jinja2_time](https://github.com/hackebrot/jinja2-time) in the copier environment.
  Install both with `uv tool` by running:

  ```shell
  uv tool install copier --with jinja2-time
  ```

* **just**

  The project contains a `justfile` with pre-defined complex commands.
  To execute these commands you need [just](https://github.com/casey/just) as command runner. Install it by running:

  ```shell
  uv tool install rust-just
  ```

## Creating a new project

### Step 1: Generate the project files

To generate a new Monarch project first create a new empty directory for the project and then run the following:

```shell
cd path/to/new/directory
copier copy --trust https://github.com/monarch-initiative/monarch-project-copier .
```

The `--trust` option is needed because the template uses the jinja_extension `jinja2_time`.

You will be prompted a few questions.
The defaults are fine for most projects, but pick the name for your project carefully as it will also be used as project name on GitHub.

It is also possible to use non-default branches or specific tags via `--vcs-ref` which is useful when developing the template:

```shell
copier copy --trust --vcs-ref branch-name gh:monarch-initiative/monarch-project-copier ./path/to/destination
```

### Step 2: Set up the Monarch project

Change to the folder your generated project is in.

Setup your project

```shell
cd my-awesome-code  # using the folder example above
just setup
```

### Step 3: Edit the code

Edit the code!

For developing consistent, well-formatted codes, the project provides a [pre-commit](https://pre-commit.com/) configuration for some helpful tools.
Included are [yamllint](https://github.com/adrienverge/yamllint) for consistent formatting of the code-yaml file,
[ruff](https://docs.astral.sh/ruff/) for formatting and linting Python code and
the spell checkers [codespell](https://github.com/codespell-project/codespell) and [typos](https://github.com/crate-ci/typos). To use this

* install pre-commit with: `uv tool install pre-commit`
* activate pre-commit in the project by running (at the root of the project): `pre-commit install`

Once installed pre-commit will perform the checks on every commit and reject a commit if errors are found;
it will even auto-correct several types of errors.
You can also run the pre-configured checks manually with `pre-commit run -a`.

### Step 4: Validate the code

```shell
just test
```

This commands generates the project artefacts from the code, runs pytest for the Python datamodel and tests loading all valid & invalid data examples.

Another important command to check your code is

```shell
just lint
```

which runs the monarch linter on your code.

### Step 5: Generate documentation locally

Monarch generates code documentation automatically.
The template includes the configuration for generating and publishing the documentation with GitHub whenever you push code changes to GitHub.
The published documentation can be found at a URL like this one:
`https://{github-user-or-organization}.github.io/{project-name}/`

You can also preview the documentation locally before pushing to GitHub by running:

```shell
just testdoc
```

### Step 6: Create a GitHub project

1. Open [GitHub new project](https://github.com/new) and follow the instructions, being sure to NOT add a `README` or `.gitignore` file
   (this copier template will add those files for you)

2. Add the remote to your local git repository:

   ```shell
   git remote add origin https://github.com/{github-user-or-organization}/{project-name}.git
   git branch -M main
   git push -u origin main
   ```

3. Configure your repository for deploying the documentation as GitHub pages

* Under Settings > Actions > General in section "Workflow Permissions" mark "Read repository and packages permission".
* Go to "Actions" tab, select on the left under Actions "Deploy docs", and click the "Run workflow" button on the right.
  Run from main-branch as suggested and verify successful completion.
* Now go back to Settings > Pages. In section "Build and Deployment" select
  * Under "Source": "Deploy from a branch"
  * Under "Branch": "gh-pages" and "/ (root)"
    * Hint: The "gh-pages" branch is created automatically in the first successful run of the "deploy docs" workflow.

### Step 7: Register the code

See [How to register a code](https://monarch.io/monarch/faq/contributing.html#how-do-i-register-my-code)

### Making releases

See [How to Manage Releases of your Monarch Code](https://monarch.io/monarch/howtos/manage-releases.html)

## Migrating an existing project to use this template

This is a rough guide on the required steps.
Feedback and suggestions for improvement based on your experiences are very welcome.
The commands are written to be run at the root of your project.

* Start with a clean state of the existing project (check with `git status`).
* Create a new branch and activate it:

  ```shell
  git switch -c migrate-to-copier
  ```

* Adapt your project and create a copier answers file (`.copier-answers`) by running (this updates to the latest released version):

  ```shell
  copier copy --trust gh:monarch-initiative/monarch-project-copier .
  ```

  * **Starting from a monarch-project-cookiecutter based project**:
    You may want to migrate in two steps to reduces the number of changes to review.
    For the first step, a migration to the 0.1.x-series is suggested,
    which still has the same directory layout as monarch-project-cookiecutter.
    The command for migrating to a specific tag/release is:

    ```shell
    copier copy --trust --vcs-ref v0.1.7 gh:monarch-initiative/monarch-project-copier .
    ```

    Look into the `.cruft.json` file to find out which values you chose when you created your original project.
    Be sure to enter the same values when answering the copier questions.

* Carefully review the changes that copier made to your project.
* If you used a cruft/cookiecutter template before, you may delete the cruft file `.cruft.json`.
* If you are happy, commit all changes to the `migrate-to-copier` branch.
* To finalise the migration, merge the `migrate-to-copier` branch to your main branch.

## Keeping your project up to date or changing its configuration

Copier allows you to update your project with changes from the template.
You can also change the project by providing different answers to the questions than the last time.

To update your project with changes from the template and to reconfigure your project options, run:

```shell
copier update --trust
```

To do a pure update without re-configuration run:

```shell
copier update --trust --skip-answered
```

If you initialized the project from a non-default branch, you must add the git branch name (or tag name) also to the update commands:

```shell
copier update --trust --vcs-ref branch-or-tag-name --skip-answered
```

When updating, Copier will do its best to respect the project evolution by using the answers provided last time.
However, sometimes this is impossible and conflicts occur.
They will be inlined into the conflicting files and can be resolved just like any other git conflict.

For more on updating see copier's [documentation](https://copier.readthedocs.io/en/stable/updating/).

## PyPI Releases

TODO: info on trusted publishers

## Contributors

A big thanks to all [contributors](https://github.com/nfdi4cat/pid4cat-model/graphs/contributors).

Main author:

* David Linke (ORCID: 0000-0002-5898-1820) - Idea, initial setup of repository and current maintainer.


## Acknowledgement

[monarch-project-cookiecutter](https://github.com/dalito/linkml-project-cookiecutter) by David Linke (ORCID: 0000-0002-5898-1820) provided a great basis for starting this new monarch project template.
