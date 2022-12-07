### Solutions thought process for fixing the payment page issue

The issue borders largely on two main areas
- poorly written DB queries
- poor design architecture

#### DB queries
A lot of the DB queries could have been made more efficient via eagerloading as opposed to the nested queries that is currently implemented. Simply put, it's the classic "N+1" query problem.
This alone would cut down on the time the server takes to execute the DB requests and making the resources available to the application

#### Design issues
It is poor design choice to place logic code in the views templates
The proper thing to do is to separate code logic to the models, controllers and the helpers or services

for example, the following blocks
```
<%
  projects = Project.all

  dates = projects.each_with_object(Hash.new { |k, v| k[v] = [] }) do |project, output|
    output[project.payment_date] << project.title
  end
%>
```

```
<%
    dates.sort_by { |date, _project| date }
         .select { |date, _project| date >= Date.current }
         .to_h
         .keys
         .each do |date|
%>
```

```
<%=
  project = Project.find_by(title: project)
  applicants = Applicant.all.select do |applicant|
    if applicant.project.title == project.title &&
        applicant.status == 'approved'
      true
    else
      false
    end
  end

  applicants.map(&:name).join(', ')
%>
```

Could all easily have been refactored into helper methods and then referenced in the views
this is very important because in the future, one may need some of these features in various other places and separating then into helpers like this keeps the application as DRY as possible
