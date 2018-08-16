# CS-372, Operating Systems
 > Syllabus, Fall 2018
---------------------
### Summary Information

_   | _
-----------|------------------
**Professor** | Thomas C. Bressoud (Dr. B)
**Office**    | Olin 211  
**Email**  |  bressoud@denison.edu
**Office Hours**  |  MTF: 2:00 p.m. to 3:00 p.m. <br> W: 3:00 p.m. to 4:00 p.m.
**Class Meeting**  | MWF: 9:30 - 10:20 a.m., Higley 105 <br> T: 8:00 - 8:50 a.m.
**Final Exam**  |  Tuesday, Dec. 18, 2:00 - 4:00 p.m.
**Course Page**  |  https://notebowl.denison.edu
**Schedule**  |  [CS-372 Schedule on Google Drive](https://docs.google.com/spreadsheets/d/1hUUEJAhbeXNBY0t1aUc3dpKbpTLxOpRyWBpboOEYguU/edit?usp=sharing)

### Description

In the Operating Systems course, we will study the principles of modern operating systems, whose fundamental charter is to manage a collection of concurrent processes. Generally speaking, an operating system provides a set of abstractions (e.g., files, memory, console I/O) to an application programmer so that the programmer need not worry about low level details of the underlying hardware. Programs themselves are abstractly viewed as a collection of concurrent processes. The operating system must correctly and efficiently manage these processes (or threads) as well as other computer resources. Therefore, we will spend a lot of time studying how to correctly handle concurrency and how resources such as memory and files are managed by the operating system.

Following the pedagogical approach of our textbook, we will partition the functionality of the operating system into three thematic areas: virtualization, concurrency, and persistence. The virtualization perspective allows us to understand the policies and mechanisms that allow us to define the abstraction of a process as a virtual CPU and a virtual range of memory. The persistence perspective allows us to understand the abstraction of the file system. And the concurrency perspective gives us the foundation for both a number of other essential abstractions and the tools to build correct implementations of the other virtualization and persistence.

There will be two basic lines of work in this class. First, the lectures, assigned reading, and written homework assignments will primarily focus on fundamental operating system concepts, including process synchronization and scheduling, resource management, memory management and virtual memory, and file systems. Second, through a sequence of programming assignments (the Pintos projects), you will apply these concepts to the construction of your own operating system capable of supporting the execution of user-level C programs.

### Final Exam

Tuesday, December 18, 2 - 4 p.m.

### Textbook

The following textbook is required for the course:

*   _[Operating Systems: Three Easy Pieces.](http://www.ostep.org/)_ by Remzi H. Arpaci-Dusseau and Andrea C. Arpaci-Dusseau.

In addition, resources (primarily in the form of PDF files) will be provided for the Intel architecture and other tools we will be using.

We will be using Notebowl, https://notebowl.denison.edu, for class discussion. Rather than emailing questions to the teaching staff, I encourage you to post your questions on Notebowl.  If you email a question to me, I will respond by asking you to post your question to Notebowl.  So you are more likely to get your answer more quickly by going to Notebowl straight away.

Assignments can be found on Notebowl, as can this syllabus.  Linked to from Notebowl Documents is our daily calendar/schedule, placed on Google Drive, and you will refer to it often.
*   [CS372 Schedule on Google Drive](https://docs.google.com/spreadsheets/d/1hUUEJAhbeXNBY0t1aUc3dpKbpTLxOpRyWBpboOEYguU/edit?usp=sharing)

### Coursework

The primary forms of coursework in CS-372 include:

*   Short turn-around homework exercises. Also included in this category will be quizzes to assess current topics, readings, and lectures. All of these exercises will be counted for their completion, and a subset will be graded more rigorously. Expect at least two items in this category each week. I will drop the lowest quiz grade and will give “extra credit” opportunities to further help in this area.  Quizzes may *not* be made up.
*   A major component of this class is the set of operating systems projects. Spread throughout the semester, these are significantly more complex, and will involve skills you have not developed before. Not all projects will take the same amount of out-of-class time so always start early.
*   There will be three “midterm” exams during the semester, currently scheduled for the end of weeks 4, 8 and 12. These will focus on material covered since the last exam, but much of our work is cumulative, so there may be some forms of repetition in subsequent exams. There are no makeup exams and alternate scheduling only occurs (ahead of the scheduled time) for a University-sanctioned excuse.
*   There will be a cumulative Final Exam. Final exams are mandated by the University to be given at the scheduled time, so it is your responsibility to ensure that no end-of-semester travel plans interfere with your taking the final at its appointed time.

### Grade Determination

Category    |   Weight
-----------:|:--------------------------:
Homework/Quiz | 15%
OS Projects   | 0: 2%, 1: 6%, 2: 8%, 3: 12%, 4: 12%
Midterms (3)  | 24%
Final         | 18%
Participation | 4%

### Policies

#### Homework Project Policy and Responsibility

You may generally discuss strategy and techniques for programming problems with other students in the class, but these should be conceptual (communicate in \_diagrams\_), and the programs must be on your own. You should never leave a collaboration having written down code generated in the discussion. Sitting next to someone in the lab while you discuss/point out/ help debug one another’s code is absolutely unacceptable and is a violation of academic integrity. I possess and run programs that measure the “closeness” of submitted code (look up the MOSS Plagiarism Detection Software system), so it is easy to tell when unacceptable collaboration is occurring. In such cases, I am obligated to report the instance to the office of the provost for action.

#### Attendance and Participation Policy and Responsibility

I expect a high level of participation by all the students in this class. True learning requires an active role and regular attendance in order to engage and master the material. Thus, I expect your attendance at every class meeting. Besides the direct grade-effect on quizzes and and in-class activities that become homework exercises, there is the 4% participation part of the grade that I will use in instances of lack of attendance or participation during class.

You are responsible for all reading assignments, whether or not the material is also covered during class time, as well as for announcements and decisions made relative to coursework that may occur during classtime. If you miss class, it is **_your responsibility_** to get notes and information on the material that was conveyed during any class you might miss.

#### Academic Honesty

Academic honesty, the cornerstone of teaching and learning, lays the foundation for lifelong integrity. Academic dishonesty is intellectual theft. It includes, but is not limited to, providing or receiving assistance in a manner not authorized by the instructor in the creation of work to be submitted for evaluation. This standard applies to all work ranging from daily homework assignments to major exams. Students must clearly cite any sources consulted—not only for quoted phrases but also for code, ideas, and information that are obtained externally. Neither ignorance nor carelessness is an acceptable defense in cases of plagiarism. Students should ask their instructors for assistance in determining what sorts of materials and assistance are appropriate for assignments and for guidance in citing such materials clearly.

For further information about the Code of Academic Integrity see [http://www.denison.edu/forms/code-of-academic-integrity](http://www.denison.edu/forms/code-of-academic-integrity).

#### Disability Accommodation

Any student who thinks he or she may need an accommodation based on the impact of a disability should contact me privately as soon as possible to discuss his or her specific needs. I rely on the Academic Support & Enrichment Center in 102 Doane to verify the need for reasonable accommodations based on documentation on file in that office. Accommodations such as time and a half for exams must be arranged ahead of time.e
