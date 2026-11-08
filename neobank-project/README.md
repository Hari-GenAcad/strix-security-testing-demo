# NeoBank ARIA

NeoBank ARIA is a fictional AI banking assistant supplied as the local target
for the Strix security-testing exercise. All customers, accounts, balances, and
transactions in this project are fictional.

## Exercise purpose

Use Strix to inspect the source, then review its findings yourself. Do not assume
that every reported issue is correct, unique, or complete. The goal is to learn
how to turn scanner output into a small, evidence-based security report.

The project contains:

- `app.py` — Streamlit user interface and login flow
- `agent.py` — AI-agent setup and tools
- `database.py` — SQLite initialization and query helpers
- `knowledge_base.py` — fictional banking policies
- `seed_data.py` — fictional customer and transaction records
- `requirements.txt` — Python dependencies

## Optional local application setup

Running the application is not required for a source scan. If your instructor
asks you to run it, use Python 3.10 or newer and a virtual environment.
The optional architecture/security-guide HTML pages are not included in this
source-only snapshot, so those UI pages are unavailable. The application creates
its own local SQLite database when started; that database is not supplied here.

Windows PowerShell:

```text
python -m venv venv
.\venv\Scripts\Activate.ps1
python -m pip install -r requirements.txt
python -m streamlit run app.py
```

macOS or Linux:

```text
python3 -m venv venv
source venv/bin/activate
python -m pip install -r requirements.txt
python -m streamlit run app.py
```

The live chatbot requires a user-supplied OpenAI Platform API key. Never place a
key in this repository. The Strix source scan described in the root README does
not require you to start the application or call its live chatbot.

## Safety

- Work only inside this fictional training project.
- Do not enter real banking or personal data.
- Do not commit credentials, databases, environments, caches, or logs.
- Keep an untouched copy because security tools may write to their target folder.
- Do not use this training implementation as a production banking application.
