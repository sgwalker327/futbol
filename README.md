## Futbol Read Me
### Demonstration of Functional Completeness
To run this program you need to run the command 'ruby spec/runner.rb' from the root directory, once the pry is hit any method within our project can
be called on the the stat_tracker object to see the various statistics.

### Technical Quality and Organization of Code
- At a high level (not line by line), describe how you broke out this application. What classes did you create? What is the responsibility of each class? Why did you choose to design your code in this way?
    The Stat Tracker class was made to run all of the statistical analysis methods. The Game class was made to handle all of the methods that run primarily through the games.csv file. The Game Teams class was 
  made to handle all of the methods that run primarily through the game_teams.csv file. The Team class was made to handle all of the methods that run primarily through the teams.csv file.

- Is there a design decision that you made that you’re particularly proud of?
    The use of modules was helpful in alowwing our classes to be clear and concise.

- Did you use inheritence and/or modules in your project? Why did you choose to use one over the other?
    We used modules in our project in order to condense and clarify our classes.

- Were you able to implement a hash at some point in your project? If so, where? And why did you choose to use a hash instead of another data type?
    Yes. Hashes allowed us to properly group data with immutable keys such as teams, coaches, and specific seasons. You can find multiple examples of this
  in our groupable module.

### Identifying areas of code that you decided to refactor
- How did you identify areas of code to refactor? At a high level, how did you go about refactoring?
    We identified areas to refactor by looking through our classes and finding places where code was being repeated and implemented helper methods
  to help dry up our code.

- Are there other areas of your code that you still wish to refactor?
    If we had the time we would refactor some of the helper methods in helpable and maybe explore more eneumerables besides .each.

### Discussion of collaboration/version control
- What was your collaboration like in this group project? How was it different working in a larger group compared to pairs?
    We feel like collaboration over all went well. The major difference for us was using github effectively.
- Were there any tools that you used to make collaboration easier?
    Outside of slack, not really.

### Discussion of test coverage

- What was it like using the Spec Harness for this project? How did it inform your design or testing choices?
    At first it was a bit difficult, but ultimately the spec harness ended up being useful in the more intricate parts of our project. It handily helped guide
  some of our method and test creations.

### Group Questions
- What was the most challenging aspect of this project?
    The favorite opponent and rival method's were definitely a bit of a blocker for us. The practice of working between so many files was also challenging.
  We also found it challenging to break down some of the methods into smaller chunks and that added a bit of overall time to our project. There were also 
  some githup snafus along the way, but those were more annoying than anything.

- What was the most exciting aspect of this project?
    Solving problems and seeing tests pass were definitely the most exciting aspect of this project and absolutely helped keep our momentum moving forward.

- Describe the best choice enumerables you used in your project. Please include file names and line numbers.
    The best choice eneumarable we used was .group_by. You can find this usage in line 3 of ./modules/groupable as well as many other places througout
  our project.

- Tell us about a module or superclass which helped you re-use code across repository classes. Why did you choose to use a superclass and/or a module?
  We would choose our groupable module. It allowed us to pull grouped chunks of manipulated data and reuse the data across classes.

- Tell us about 1) a unit test and 2) an integration test that you are particularly proud of. Please include file name(s) and line number(s).
  1) Unit Test - Win_average_helper (File: team_spec.rb, Line: 203)

  2) Integration Test - Rival and Favorite Opponent (File: team_spec.rb, Line: 210, 216)

- Is there anything else you would like instructors to know?
  We're excited to hear your feedback.
  
### Q&A

- **Kara**
Before we would usually just do something like stat_tracker = StatTracker.new instead of calling a class method to initialize an instance of the class. Is it better to do one way or the other? And why?

- **Jade**
What are the steps you usually take to break down a problem into digestible pieces?

- **Sam**
Looking at our project, where would you implement inheritance?

Starter repository for the [Turing School](https://turing.io/) Futbol project.
