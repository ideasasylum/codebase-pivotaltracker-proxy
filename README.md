Introduction:
=============

A simple Sintra app which acts as a proxy between Pivotal Tracker and Codebase, enabling you to see your codebase tickets in pivotal tracker. An instance of this proxy is running at http://codebase2pivotaltracker.heroku.com and you're free to use it, or deploy your own.

Usage:
======

- Add a new integration to PivotalTracker: Open your project, View->Settings, Integrations. Scroll down to the bottom and choose 'Other' from the "Create New Integration..." drop down menu.
  *Name*: Codebase (of whatever you'd like to call this)
  *Basic Auth Username*: <your codebase username>
  *Basic Auth Password*: <your codebase ***apikey***>
  *Base URL*: http://<your codebase subdomain>.codebasehq.com/<project name>/tickets/
  *Import API URL*: http://codebase2pivotaltracker.heroku.com/tickets/<your codebase subdomain>/<project name>

- Go back to your story. View->Codebase. This will open a new column with your codebase tickets which can be dragged into the other columns. Codebase stories will have an ID number which will link back to the full codebase ticket.

Limitations
===========

- Codebase doesn't provide the ticket creation date so this isn't set properly
