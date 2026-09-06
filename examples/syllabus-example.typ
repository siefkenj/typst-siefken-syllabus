#import "@preview/elembic:1.1.1" as e
#import "../src/lib.typ" as s

#show: e.set_(
  s.settings,
  code: "Mat 244",
  name: "Differential Equations",
  term: "Fall 2025",
  font_sans: it => text(font: "GeosansLight", baseline: -0.3em, it),
  term_start_date: datetime(year: 2025, month: 9, day: 2),
  term_end_date: datetime(year: 2025, month: 12, day: 2),
  tutorial_start_date: datetime(year: 2025, month: 9, day: 16),
  basic_info: (
    (title: "Textbook:", value: [_Differential Equations_ by Galvão-Sousa & Siefken]),
    (title: "Course webpage:", value: [https://q.utoronto.ca]),
  ),
  holidays: (
    (
      name: [Thanksgiving],
      type: "holiday",
      key: "thanksgiving",
      date: datetime(year: 2025, month: 10, day: 13),
      //duration: duration(days: 1)
    ),
    (
      name: [Reading break],
      key: "reading-break",
      type: "holiday",
      date: datetime(year: 2025, month: 10, day: 27),
      duration: duration(days: 5),
    ),
  ),
  events: (
    (
      name: "Midterm 0",
      type: "test",
      key: "midterm",
      date: datetime(
        year: 2026,
        month: 10,
        day: 18,
        hour: 17,
        minute: 10,
        second: 0,
      ),
      duration: duration(minutes: 110),
    ),
    (
      name: "Midterm",
      type: "test",
      key: "midterm",
      date: datetime(
        year: 2025,
        month: 10,
        day: 18,
        hour: 17,
        minute: 10,
        second: 0,
      ),
      duration: duration(minutes: 110),
    ),
    (
      name: "Dec. Group Assessment",
      type: "test",
      key: "dec-group-assessment",
      date: datetime(
        year: 2025,
        month: 12,
        day: 1,
        hour: 17,
        minute: 10,
        second: 0,
      ),
      duration: duration(minutes: 110),
    ),
    (
      name: "Homework Quiz 1",
      type: "homework",
      date: datetime(
        year: 2025,
        month: 9,
        day: 19,
      ),
    ),
    (
      name: "Fun Day",
      type: "project",
      date: datetime(
        year: 2025,
        month: 9,
        day: 19,
        hour: 17,
        minute: 10,
        second: 0,
      ),
    ),
  ),
)

#show: s.template

Differential equations revolutionized modern science when Newton and Leibniz invented them along
with the _Calculus_. Since then they have been studied intensely. They are the go-to modeling technique for physical phenomena like weather, climate, quantum mechanics, ecology, turbulence, and much more.

Despite having been studied for more than 300 years, differential equations are still an active area
of research. The most famous unsolved differential equations are the _Navier–Stokes equations_ which describe the flow of compressible fluids. If you find all solutions to the Navier–Stokes equations, the Clay Mathematical Institute will issue you a cheque for \$1 million!

This course focuses on the so-called _ordinary_ differential equations, which are equations relating a
function and its derivatives, but which don't include any _partial derivatives_. For example, $f'(x) =
f (x)$ is a famous ordinary differential equation (whose equally-famous solutions include $f (x) = e^x$).

Sadly, most differential equations cannot be solved in terms of known functions. So, this course takes
a simulation-based approach to understanding differential equations and apply differential equations
to model real-world scenarios.

== Learning Outcomes

After taking this course, you will be able to:
- Model real-world scenarios using differential equations.
- Use a computer to approximate the solutions to differential equations and systems of differential equations and explain the advantages and draw-backs of computer-based approximations.
- Apply linear algebra techniques to classify solutions of linear systems of ordinary differential equations including rigorously classifying the stability of equilibrium solutions and creating linear approximations to non-linear systems of ordinary differential equations.
- Interpret and analyze models based on differential equations using tools like simulation, phase portraits, analysis of stability, and linear approximation.

== To Succeed

Learning is hard! It is exercise for the mind, and like exercise, when you’re doing it, it feels pretty
uncomfortable. Here are some tips to help you succeed academically (getting the grade you want)
and intellectually (learning the most you can).

- Form a regularly-meeting study group of 3--4 people. Math should
  not be done in isolation! You need others to bounce ideas off of and
  to motivate you when you're feeling down.

- Read the textbook _before_ class. A good rule of thumb is _every hour
  spent studying before class is worth two hours of studying after class_.
- Force yourself to explain. When reviewing, it's easy to glance at a solution
  and think, ``Oh yeah, I knew that.'' Don't do it! Force yourself to
  explain each problem/concept without referencing a solution. Be patient with
  yourself---it might take 5 or 10 minutes before it finally comes to mind, but
  studying this way will be significantly more effective.

== Prereq's

To be prepared for this course, you need to have a solid understanding
of Linear Algebra (MAT223) and Calculus (MAT135/136 or MAT137). If you're feeling
shaky on either of those topics, start reviewing earlier rather than later.

== Homework

Throughout the semester you will be given homework assignments. Your homeworks
will be a mix of review from previous classes (MAT223 and MAT135/136/137), exploration of
course concepts, and practicing algorithms common in a first differential equations course.

Homeworks will not be submitted. Instead, you will be given homework quizzes in tutorials.

== Assessment

#s.annotated_item(
  title: "Homework Quizzes",
  subtitle: "30%",
)[In tutorial you will have homework quizzes. Your lowest homework quiz will be dropped.]

#s.annotated_item(
  title: "Midterm",
  subtitle: "30% or 25%",
)[
  There will be one midterm exam on #s.get_event_time("midterm").
]

#s.annotated_item(
  title: "Dec. Group Assessment",
  subtitle: "10%",
)[
  Near the end of the semester there will be a group assessment where you will work with a small team to answer
  questions about a differential-equations based model.
]

#s.annotated_item(
  title: "Final Exam",
  subtitle: "30% or 35%",
)[
  A comprehensive final exam will take place during the final exam period in December. The date and time will be
  determined by FAS.
]

Your course mark will be computed as a weighted average of the above components. Whichever of the
weights 30/30/10/30 or 30/25/10/35 gives the higher mark will be used to compute your course mark.
(See the left column for weights.)


== Missed Assessments

=== Exams
If you have a legitimate academic conflict with an exam time (for example, the scheduled exam time
occurs during a U of T course you are registered for) and need to register for an early sitting, please
email #link("admin244@math.toronto.edu") and include (1) an explanation of why you need an early
sitting and (2) a screenshot of your ROSI/ACORN schedule showing a legitimate conflict.

There will be no make-up exams and unexcused missed exams will be given a score of 0. If you miss
an exam due to illness, you must submit (via Quercus) a scanned copy of a completed University
of Toronto Verification of Student Illness or Injury form (#link("http://www.illnessverification.utoronto.ca")) no later than one week after the exam.
If you legitimately miss a midterm exam, your final exam score will count as your midterm score for
the missed midterm.

=== Homeworks

No late homeworks will be accepted for any reason, including illness. Do not submit a verification
of illness form for missed homeworks. Instead, your lowest homework score will be dropped. This
accommodates those who are sick or have other issues arise during the semester.

If you find yourself in a situation where you will miss a large portion of the semester and/or assignments, please contact your college registrar to discuss accommodation options.

== Email & Etiquette

We will try to respond to emails as soon as possible, but during busy times
(like before an exam) it might take several days to respond. If your
situation is urgent, talk to a professor after class or in office hours.

When writing an email:

- *Put MAT244 in the subject line, use your #link("utoronto.ca") email, and
  identify yourself by name and UTORid*.
- *Be specific*. We're better able to help you if you're specific about your issue
  and you include all necessary information. If your situation is complex, it
  is best to come to office hours to discuss it.
- *Check the syllabus and course webpage first*. If your question is answered on
  the syllabus or the course webpage, we may not respond to your email.
- *Be professional*. Please use appropriate tone and level of formality in your
  emails. Do not use slang or texting abbreviations. It is tradition in North America
  to start emails _Dear Professor ..._, and end them, _Thank you, ..._.
- *No content questions*. If you have mathematical questions, please bring your
  question to office hours.

== Lectures & Contacts

There are several lecture sections. (R means Thursday)

#context {
  show table.cell.where(y: 0): strong
  //let w = page.width - page.margin.left - page.margin.right
  let w = page.width - 2in
  pad(left: calc.min(w - 6.8in, 0pt), table(
    align: center,
    stroke: 0.5pt,
    columns: (auto, auto, auto, auto, 1fr, auto),
    table.header([Section], [Time], [Room], [Instructor], [Email], [Office]),
    [LEC0101],
    [W9--11, F10--11],
    [MB 100],
    [B.~Galvão-Sousa],
    [#link("some-prof@math.toronto.edu")],
    [BA 1114],
  ))
}

== Tutorials

You must register in a tutorial section through ROSI/ACORN by the end of
the first week of classes. Tutorials will begin #s.get_event_time("tutorial_start_date").

_Your must attend the tutorial you signed up for._

Attendance in tutorials is mandatory. During tutorials, you will be working
on solving complex and novel problems and additionally practicing your mathematical
writing. Tutorials are *not about answers* to problems. They are about
_practice_. Thus, you shouldn't expect to go over every tutorial problem
during a tutorial.


#pagebreak()
== Academic Resources

#v(.5em)

#s.annotated_item(
  title: "Accessibility Needs",
)[
  The University of Toronto is committed to accessibility.
  If you require accommodations for a disability, or
  have any accessibility concerns about the course, the classroom or course materials,
  please contact Accessibility Services #link("http://www.studentlife.utoronto.ca") as soon as possible, really.
]

#s.annotated_item(
  title: "English Language Instruction",
)[
  For information on campus writing centres and writing courses,
  please visit #link("http://www.writing.utoronto.ca").
]

#s.annotated_item(
  title: "Other Resources",
)[
  Student Life Programs and Services #link("http://www.studentlife.utoronto.ca")\n
  Academic Success Centre #link("http://www.studentlife.utoronto.ca/asc")\n
  Health and Wellness Centre #link("http://www.studentlife.utoronto.ca/hwc")
]

#v(2em)
== Academic Integrity

Academic integrity is fundamental to learning and
scholarship at the University of Toronto. Participating
honestly, respectfully, responsibly, and fairly in this
academic community ensures that the University of Toronto degree
that you earn will be valued as a true indication of your individual
academic achievement, and will continue to receive the respect
and recognition it deserves.

Familiarize yourself with the
#link("https://governingcouncil.utoronto.ca/secretariat/policies/code-behaviour-academic-matters-july-1-2019", [University of Toronto's Code of Behaviour on Academic Matters]).
It
is the rule book for academic behaviour at the University of Toronto, and you are
expected to know the rules.

The University of Toronto treats cases of
academic misconduct very seriously. All suspected cases of academic
dishonesty will be investigated following the procedures outlined in the
Code. The consequences for academic misconduct can be severe, including
a failure in the course and a notation on your transcript. If you have
any questions about what is or is not permitted in this course, please
do not hesitate to contact your instructor or the course coordinator.
If you have questions about appropriate
research and citation methods, seek out additional information from
your instructor or from other available campus resources like the University of Toronto Writing
Website. If you are experiencing personal challenges that are having
an impact on your academic work, please speak to your instructor or seek the advice
of your college registrar.


#pagebreak()

== Schedule

Below is a preliminary schedule for the course.
#set text(size: .6em)
#let reading(it) = s.get_setting("colors", map: colors => text(fill: colors.tertiary, it))

#s.timetable(week_start_day: "monday", weekly_data: (
  [
    Population models and Differential Equations\
    #reading([Textbook: §1.1–1.3])
  ],
  [
    Euler’s Method and Numerical Approximations\
    #reading([Textbook: §1.7])
  ],
  [
    Lotka–Volterra models, multi-dimensional Euler’s method, and Phase Portraits\
    #reading([Textbook: §2.1, §3.1])
  ],
  [
    Families of solutions and Modeling\
    #reading([Textbook: §1.6])
  ],
  [
    Matrix notation for ODEs and application of Eigenvalues to ODEs\
    #reading([Textbook: §2.2–2.3])
  ],
  [
    Phase Portraits and Affine Systems of ODEs\
    #reading([Textbook: §2.4])
  ],
  [
    Modeling with Affine Systems and Introduction to Complex Eigenvalues\
    #reading([Textbook: §2.4, Appendix B])
  ],
  [
    Complex eigenvalues cont. and Linearization\
    #reading([Textbook: §2.4, Appendix B])
  ],
  [],
  [
    Linearization cont., Affine Approximations, and Second-order ODEs\
    #reading([Textbook: §3.1–3.2])
  ],
  [
    Higher-order ODEs and Boundary Value Problems\
    #reading([Textbook: §2.6])
  ],
  [
    Famous ODEs
  ],
  [
    Famous ODEs cont.
  ],
))
