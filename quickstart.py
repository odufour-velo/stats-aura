from apiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials


SCOPES = ['https://www.googleapis.com/auth/drive.readonly']
KEY_FILE_LOCATION = 'credentials.json'
# VIEW_ID = '<REPLACE_WITH_VIEW_ID>'


def initialize_drive():
  """Initializes an service object.

  Returns:
    An authorized service object.
  """
  creds = ServiceAccountCredentials.from_json_keyfile_name(
      KEY_FILE_LOCATION, SCOPES)

  # Build the service object.
  service = build('drive', 'v3', credentials=creds)

  return service


if __name__ == "__main__":
    drive = initialize_drive()
    print(dir(drive))
    print(drive.drives)