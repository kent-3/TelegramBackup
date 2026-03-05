# TelegramBackup - Advanced Backup Solution for Telegram Chats

TelegramBackup is a comprehensive tool designed for extracting, organizing, and archiving messages from your Telegram chats, channels, and groups. It preserves not only message content but also media files, reactions, replies, forwarded content, and other rich features that make Telegram unique. Whether you need to back up personal conversations, archive large channels, or export group discussions, TelegramBackup offers a complete solution.

## Key Features

- **Complete Message Archiving**: Preserve text messages, media files, reactions, replies, service messages, and more
- **Rich Media Support**: Download and view photos, videos, voice messages, audio files, and documents
- **Interactive HTML Export**: Browse your archived messages with a clean, responsive interface similar to Telegram's own design
- **Incremental Updates**: Update existing backups with only new messages without recreating the entire archive
- **Contact Export**: Extract and save your complete contact list to CSV
- **Participant Export**: Export the member list of any group or channel to CSV
- **Message Threading**: View message replies with links to original messages and preview on hover
- **Reaction Support**: See all emoji reactions to messages just like in Telegram
- **Date Grouping**: Messages are organized by date for easier navigation
- **Multiple Entity Types**: Support for private chats, channels, supergroups, and regular groups
- **Web Preview Support**: Link previews are preserved in the backup
- **SQLite Storage**: All data is stored in a structured SQLite database for easy access and querying

## Quick Start

### Prerequisites

- Python 3.6 or higher
- A Telegram account
- Telegram API credentials (the setup script will walk you through this)

### 1. Clone and run

```bash
git clone https://github.com/kent-3/TelegramBackup.git
cd TelegramBackup
./run.sh
```

That's it. The `run.sh` script handles everything automatically:

- Checks that Python 3.6+ is installed
- Creates a virtual environment (keeps your system clean)
- Installs all dependencies
- Walks you through getting your Telegram API credentials (first run only)
- Launches the backup tool

### 2. Get your API credentials

On the first run, the script will ask for your Telegram API credentials. Here's how to get them:

1. Go to **https://my.telegram.org** in your browser
2. Log in with your phone number (Telegram sends a code to your app, not SMS)
3. Click **"API development tools"**
4. Fill in any app name and short name (e.g., "MyBackup" / "mybackup")
5. You'll get an **API ID** (a number) and **API Hash** (a long hex string)
6. Paste them when the script asks

These are saved locally in a `.env` file (never committed to git).

### 3. Authenticate with Telegram

The first time, the script will ask for your phone number and a verification code (sent to your Telegram app). After that, your session is preserved for future runs.

### 4. Use the menu

Once connected, you'll see:

```
What would you like to do?
[E] Process specific entity      - Back up a single chat, group, or channel
[T] Process all entities         - Back up everything
[U] Update existing backup       - Add only new messages to an existing backup
[P] Export participants           - Export member list of a group/channel to CSV
[D] Delete Telegram service msgs - Clean up login notification messages
[X] Logout (destroy session)     - Log out and require re-auth next time
[S] Exit                         - Exit (session preserved for next run)
```

When processing entities, you can:
- Specify how many messages to retrieve (or press Enter for all)
- Choose whether to download media files (photos, videos, documents)

## What Gets Exported

| Data | Format | Automatic? |
|------|--------|------------|
| Contacts (name, phone, username) | CSV | Yes, on every run |
| Entity list (all chats, groups, channels) | CSV | Yes, on every run |
| Messages (text, media, reactions, replies) | SQLite + HTML | When you choose [E], [T], or [U] |
| Group/channel member lists | CSV | When you choose [P] |
| Media files (photos, videos, voice, docs) | Original files | Optional per backup |

## Accessing Your Backup

- **HTML files**: Open in any browser for a Telegram-like chat view with media playback, reactions, and threaded replies
- **SQLite databases**: Open with [DB Browser for SQLite](https://sqlitebrowser.org/) or query with any SQLite tool
- **CSV files**: Open with Excel, Google Sheets, or any spreadsheet app
- **Media files**: Saved in `media/[entity_id]/` directories

## HTML Export Features

The generated HTML export includes:

- Messages grouped by date
- Sender information on each message
- Reply threading with hover previews
- Emoji reactions with counts
- Inline audio/video/image playback
- Web link previews
- Service messages (joins, leaves, title changes)
- Forwarded message attribution with source links
- Responsive mobile-friendly layout

## Database Structure

The SQLite database contains the following tables:

- **messages**: Core message data including text, media, timestamps, and metadata
- **buttons**: Message buttons and inline URLs
- **replies**: Reply relationships between messages
- **reactions**: Emoji reactions to messages with counts

## Tips for Large Backups

1. **Start small**: Test with a limited number of messages (e.g., 1000) first
2. **Ensure adequate storage**: Media files can consume significant disk space
3. **Use incremental updates**: After the initial backup, use [U] for periodic updates
4. **Be patient**: Large backups can take considerable time due to Telegram rate limits

## Troubleshooting

**"Python not found"**: Install Python 3.6+ using your system's package manager. The error message from `run.sh` will show you the right command.

**Connection errors**: Check your internet connection. Some networks block Telegram's API servers — try a different network or VPN.

**"Cannot export participants"**: Some groups restrict member lists to admins only. You'll need admin privileges in that group.

**Session errors**: Delete any `.session` files in the project directory and re-authenticate.

**Encoding issues in CSV**: Open CSV files in a modern spreadsheet app rather than a text editor.

## Manual Setup (Alternative)

If you prefer not to use `run.sh`:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your API credentials
python telegram_backup.py
```

## Ethical Use and Legal Considerations

**TelegramBackup** is intended for personal use, enabling users to backup their own Telegram data. The misuse of this tool, such as unauthorized data extraction from accounts or channels where you do not have permission, is strictly prohibited. Ensure that all data you process with this tool complies with Telegram's terms of service and local data protection laws.

## License

This script is provided under the GNU Affero General Public License v3.0. You can find the full license text in the [LICENSE](LICENSE) file.
