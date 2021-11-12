import argparse as ap
import requests as rq
from pywebcopy import save_webpage
import subprocess
import os
import sys
from pathlib import Path


#defining a function for url verification
def url_verification(url):
    try:
        response = rq.get(address, timeout=5) 
    except rq.ConnectionError as connection_error:
        raise SystemExit(connection_error)

    except rq.TooManyRedirects as toomany_request:
        raise SystemExit(toomany_requests)

    except rq.Timeout as time_out:
        raise SystemExit(time_out)

    except rq.HTTPError as generic_error:
        raise SystemExit(generic_error)

    except Exception as e:
        raise SystemExit(e)

#defining a function that  downloads contents from verified url and adds it to a folder
def download_contents(url, download_folder_name):
    url_verification(url) 
    content_path = str(Path(__file__).parent.absolute())
    kwargs = {'bypass_robots': True, 'project_name': download_folder_name}
    save_webpage(url, content_path, **kwargs)

def argument_parser():
    parser = ap.ArgumentParser()

    parser.add_argument('--url', type=str, required=True)
    parser.add_argument('--http_server', action='store_true')
    args = parser.parse_args()
    return args

def main():
    download_folder_name = 'ExtractedContents' #the folder where contents are to be downloaded is ExtractedContents
    args = argument_parser()
    if args.http_server:
        download_contents(args.url, download_folder_name)
        subprocess.run(list(f'python3 -m http.server -d {download_folder_name} '.split()))
    else:
        download_contents(args.url, download_folder_name)
   


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('interrupted via keyboard')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
