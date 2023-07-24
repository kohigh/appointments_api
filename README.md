# Dentist Appointment Scheduler

## Description

The Dentist Appointment Scheduler is an api application that allows patients to self-select convenient time slots for their next dentist appointment. The application calculates and displays all available appointment times for a specific dentist within a given date range.

## Installation

Follow these steps to set up the Dentist Appointment Scheduler locally:

1. Clone the repository: `git clone`
2. Install dependencies: `bundle`
3. Set up the database: `rails db:setup`
4. Start the Rails server: `rails s`
5. Install node lib `npm install axios`
6. Run js script `node grabAppointments.js` to get available time for a dentist(check seeds.rb).
   ```ruby  
   Appointments: [
      # 2021-01-04
      {"from"=>"2021-01-04T08:00:00", "to"=>"2021-01-04T08:30:00"}, 1 slot is available
      {"from"=>"2021-01-04T10:00:00", "to"=>"2021-01-04T10:30:00"}, 5 slot is available
      {"from"=>"2021-01-04T11:00:00", "to"=>"2021-01-04T12:00:00"}, 7-8 slots are available
      # after lunch
      {"from"=>"2021-01-04T13:00:00", "to"=>"2021-01-04T18:00:00"}, 11-18 slots are available
      
      # 2021-01-05
      {"from"=>"2021-01-05T08:30:00", "to"=>"2021-01-05T12:00:00"}, 2-8 slots are available
      # after lunch
      {"from"=>"2021-01-05T14:30:00", "to"=>"2021-01-05T18:00:00"}, 14-18 slots are available
      
      # 2021-01-06
      {"from"=>"2021-01-06T08:00:00", "to"=>"2021-01-06T12:00:00"}, 1-8 slots are available
      # after lunch
      {"from"=>"2021-01-06T13:00:00", "to"=>"2021-01-06T18:00:00"}, 11-18 slots are available
   ]

## Database Schema

The application uses a simple database schema with the following tables:

- Users: Stores information about all users(dentists and patients) (id, name, contact details, etc.).
- Appointments: Stores appointment details (id, dentist_id, patient_id, day, slot).

## Repository Structure
The repository follows a standard structure for a Ruby on Rails project. Here are the main directories and files:

- `app/`: Contains the application code, including models, controllers, services, serializers.
- `db/`: Includes the database schema and migrations.
- `config/`: Contains the project configuration files.
- `spec/`: Contains the project tests.
- `Gemfile`: Lists the required gems for this project.

## Main Concepts

- User ⇄ Appointment(dentist, patient) are related in a relationship using foreign keys dentist_id and patient_id.
- `Appointment#slot` is a 30-minute time interval starting from a specific time and extending to the next 30 minutes. In our workday, there can be 18 such slots, from 8 am to 6 pm, excluding the one-hour lunch break. This field represents a form of optimization for storing information, as the index `[date, int]` is much lighter for handling large volumes of data compared to `[datetime, datetime]`, which might seem more intuitive for this task. Additionally, the slot field simplifies and optimizes the process of calculating available slots (by avoiding the use of NOT IN or similar operations in db) and instead relies on a lightweight service `AvailableSlotsGetter`(which doesn't use any db operations). Since all possible slots are known in advance (static data), it becomes relatively easy to calculate the gaps between used slots to determine available options.
- We also have the `SlotTimeConverter` service that performs two tasks: 1) merges all consecutive slots within a range, and 2) converts slots into human-readable time intervals. In the case where we have not just a single slot but a range of slots obtained as in point 1, the time interval will span from the start of the first slot in the range to the end of the last slot in that range.

## TODOs

### Workdays

Integrate some gem or any lib that will consider all weekends and holidays in a work schedule

### Authorizations

Currently, we do not check what actions are available for dentists and patients, and whether a dentist is performing actions that only dentists should perform, and the same for patients. Therefore, we need to add a role-based authorization mechanism to authenticate user actions.

### Data migration

Considering that each day for a dentist can have up to 18 appointments, it may create complexities in maintaining the appointments table in the future. Therefore, we could explore options for data migration. For example, we could transfer all past appointments to some other non-relational database, like ElasticSearch, and remove them from PostgreSQL (which will be used for current and future appointments). This way, we could avoid potential issues with a large amount of data that could complicate the constant updating of the index ["dentist_id", "day", "slot"] and slow down the reading from the table.

### Caching

`SlotTimeConverter` combining slots is just the first step of optimization we might use here. We can choose any caching provider, as the caching scheme and what we cache are more important considerations. A reasonable caching approach, in my opinion, would be to cache the available slots for each active dentist separately for each day of the current week and the next week. The caching frequency could be determined by monitoring tools like New Relic, Scout, Grafana, Kibana, etc., to measure how often the upcoming week's available slots are requested.

To implement this, we can cache the data with keys like 'available#{dentist_id}_#{day}', where each day's availability for a dentist is stored separately. For each request for available slots, we can check if any dates within the 'from-to' range are already cached and simply add them to the result. If the entire 'from-to' period is covered by cached dates, we can combine those cached parts into a single array. However, it is crucial to keep each cached day up to date.

To achieve this, whenever the AppointmentsController#create action is triggered for a dentist on a particular day, we can invalidate the current cache and replace it with the updated values. Additionally, for further optimization, we can remove data from the cache when all available slots for a dentist end on a date that falls within the caching period. This would help with space efficiency. For queries that should be cached, we can check whether the corresponding key exists in the cache. If it doesn't, we can skip considering that date for further calculations.