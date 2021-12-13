# README

This source code is using: 
  - ruby version 3.0
  - rails version 6.1.3

This project is using SQLite for storage the data

To run this source code after clone, please run this command below: 
  - rails db:migrate
  - rails s
  => go to the browser with this link http://localhost:3000

About this project: 
  - This project use to calculate the working fee base on:
    + The week day:
      - Monday, Wednesday, Friday (7am - 7pm: $22/hour) - (Outside: $34/hour)
      - Tuesday, Thursday (5am - 5pm: $25/hour) - (Outside: $35/hour)
      - Weekend - Always $47/hour
