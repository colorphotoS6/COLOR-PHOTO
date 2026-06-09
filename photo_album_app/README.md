# Photo Album Prototype

Prototype Flask app to let a user create photo albums, upload images, store them on Google Drive, and share a gallery link. Includes simple options for download protection (password), watermarking, and likes.

Quick start

1. Create a Google Cloud project, enable the Drive API, and create OAuth 2.0 credentials (Web application) with redirect URI `http://localhost:5000/oauth2callback`. Download the JSON and save it as `photo_album_app/client_secrets.json`.
2. Create a virtualenv and install requirements:

```bash
python -m venv venv
venv\Scripts\activate
pip install -r photo_album_app/requirements.txt
```

3. Run the app:

```bash
set FLASK_APP=photo_album_app/app.py
set FLASK_ENV=development
flask run
```

4. In the browser open `http://localhost:5000`, click "Connect Google Drive" and sign in with the account you want to use for storing albums. Then create an album and upload photos.

Notes & limitations

- This is a prototype. Download protection is enforced by the app when files are not shared publicly; it cannot fully prevent users from saving images displayed in the browser. For stricter controls consider hosting processed (watermarked) images only and avoid public Drive sharing.
- The app stores Drive OAuth tokens in `photo_album_app/credentials.json` and metadata in `photo_album_app/albums.db`.
