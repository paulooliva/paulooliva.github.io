#! /usr/bin/env python

import sqlite3

# returns the list of users
def list_users(cursor):
   c.execute('SELECT * FROM {tn}'.format(tn='user'))
   return c.fetchall()

# returns the list of all (follower, following) pairs
def list_follow(cursor):
   c.execute('SELECT follower_id, following_id FROM {tn}'.format(tn='following'))
   return c.fetchall()

def number_of_followers(cursor, user_id):
   c.execute('SELECT follower_id, following_id FROM following where following_id={un}'.format(un=user_id))
   return len(c.fetchall())

# Function that finds the user with most followers
def most_popular_user(cursor):
   users = list_users(cursor)
   n = 0
   top = None
   for (user_id,un,pw) in users:
      i = number_of_followers(cursor, user_id)
      # found a more popular user
      if i > n:
         n = i
         top = un
   print('The most popular user is',top,'with',n,'followers')

# Database file
sqlite_file = 'db.sqlite3'

# Create a connection to the database
conn = sqlite3.connect(sqlite_file)

# Create a cursor with which we can operate on the database
c = conn.cursor()

most_popular_user(c)

conn.commit()
conn.close()
