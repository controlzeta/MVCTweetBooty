﻿var Tweets; var Hashtags;

$(document).ready(function () {
    setTime();
    GetHashtagByCountry();
});

function GetHashtagByCountry() {
    var table = $('#HashtagsDT').DataTable();
    table.destroy();
    $('#HashtagsDT').empty();
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/GetHashtagByCountry",
        data: "{ id: " + $('#CountryId').val() + " }",
        success: function (data) {
            Hashtags = data;
            console.log(data);
            $('#HashtagsDT').DataTable({
                "sDom": '<"top"f>rt<"bottom"lp><"clear">',
                "lengthMenu": [[25, 35, 50, -1], [25, 35, 50, "All"]],
                "destroy": true,
                "data": data,
                "columns": [
                        { "data": "Name" },
                        { "data": "Url" }
                ],
                "columnDefs": [
                {
                    "title": "Hashtag",
                    "targets": 0,
                    "render": function (data, type, row) {
                        return '<a href="' + row["Url"] + '" target="_blank"> ' + data + '</a>';
                    }
                },
                {
                    "targets": 1,
                    "searchable": false,
                    "visible": false
                }]
            });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            $.growl.error({ message: "Ajax failed!: " + xhr.error });

            //alert("Ajax Failed!!!");
        }
    }); // end ajax call
}

$("#CountryId").change(function () {
    GetHashtagByCountry();
});

function Search() {
    if ($('#query').val().length > 3) {
        console.log("{ query: '" + $('#query').val() + "' , " +
            " numberOfResults : " + $('#idResultNumber').val() + " , " +
            " resultsType : " + $('#idTypeOfResults').val() + " }");
        $.ajax({
            //cache: false,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            url: "/Home/SearchTweets",
            data: "{ query: '" + $('#query').val() + "' , " +
            " numberOfResults : '" + $('#idResultNumber').val() + "' , " +
            " resultsType : '" + $('#idTypeOfResults').val() + "' }",
            success: function (data) {
                console.log(data);
                $('#queryError').text('');
                $('#TweetsDT').DataTable({
                    "sDom": '<"top"lf>rt<"bottom"p><"clear">',
                    "lengthMenu": [[25, 35, 50, -1], [25, 35, 50, "All"]],
                    "destroy": true,
                    "data": data.Statuses,
                    "columns": [
                        {
                            "data": "IdStr",
                            render: function (data, type, row) {
                                return "<a href='https://twitter.com/" + row.Author.ScreenName + '/status/' + row.IdStr + "'  target='_blank' alt='" + row.IdStr + "'>" + row.IdStr.slice(0, 5) + "</a>";
                            }
                        },
                        {
                            "data": "Author.ScreenName",
                            render: function (data, type, row) {
                                return "<a href='https://twitter.com/" + row.Author.ScreenName + "' target='_blank'>@" + row.Author.ScreenName + "</a>";
                            }
                        },
                        { "data": "TextAsHtml" },
                        { "data": "RetweetCount" }
                    ]
                });
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.error);
                console.log(thrownError);
                console.log(ajaxOptions);
                alert("Ajax Failed!!!");
            }
        }); // end ajax call
    } else {
        $('#queryError').text('Write something to search! ');
    }
}

function setTime() {
    if (totalSeconds >= 1) {
        --totalSeconds;
        secondsLabel.innerHTML = pad(totalSeconds % 60);
        minutesLabel.innerHTML = pad(parseInt(totalSeconds / 60));
    } else {
        console.log('Tweeting');
        $.ajax({
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            url: "/Home/Timer",
            async: false,
            data: "{ id: 0 }",
            success: function (data) {
                console.log(data);
                totalSeconds = data;
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.error);
                console.log(thrownError);
                console.log(ajaxOptions);
                //alert("Ajax Failed!!!");
            }
        }); // end ajax call
    }
}

function pad(val) {
    var valString = val + "";
    if (valString.length < 2) {
        return "0" + valString;
    }
    else {
        return valString;
    }
}

$('#query').keydown(function (event) {
    if (event.which == 13) {
        Search();
    }
});


function Tweet() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/Tweet",
        data: "{ tweetText: '" + $('#TweetText').val() + "' }",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
            $.growl({ title: "Tweet", message: $('#TweetText').val() });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
            $.growl.error({ message: xhr.error });

        }
    }); // end ajax call
}

function RefreshLabels(data) {
    try {
        $('#TweetCounter').text(data.TweetCounter);
        $('#FavCounter').text(data.FavCounter);
        $('#FollowCounter').text(data.FollowCounter);
        $('#NumFotos').text(data.NumFotos);
        $('#rateLimit').text(data.rateLimit);
        popMessage(data.growlMessage, data.growlType);
    }
    catch (e) {
        console.log(e);
    }
}

function GetOldTweets() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/OldTweets",
        data: "{ howMany: 0 }",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
            $('#OldTweetsDT').DataTable({
                "sDom": '<"top"lf>rt<"bottom"p><"clear">',
                "lengthMenu": [[25, 35, 50, -1], [25, 35, 50, "All"]],
                "destroy": true,
                 "order": [[ 3, "desc" ]],
                "data": data,
                "columns": [
                    {
                        "data": "Action"
                    },
                    {
                        "data": "Text"
                    },
                    {
                        "data": "Timestamp"
                    },
                    {
                        "data": "TweetId"
                    },
                    {
                        "data": "Username"
                    }
                ],
                "columnDefs": [
                   {
                       "title": "Timestamp",
                       "targets": 2,
                       "render": function (data, type, row) {
                           return parseJsonDate(row["Timestamp"]);

                       }
                   }
                ]
            });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
        }
    }); // end ajax call
}

function RetweetSomething() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/ReTweetSomething",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
            //$.growl.notice({ message: "Just Retweeted something!" });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
            $.growl.error({ message: "Ajax failed!: " + xhr.error });
        }
    }); // end ajax call
}

function FavoriteSomething() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/FavoriteSomething",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
            //$.growl.notice({ message: "Just Favorite something!" });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
            $.growl.error({ message: "Ajax failed!: " + xhr.error });
        }
    }); // end ajax call
}

function GetMentions() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/GetMentions",
        success: function (data) {
            console.log(data.mentions);
            var root = "https://twitter.com/";
            $('#MentionsDT').DataTable({
                "sDom": '<"top"lf>rt<"bottom"p><"clear">',
                "lengthMenu": [[25, 35, 50, -1], [25, 35, 50, "All"]],
                "destroy": true,
                "data": data.mentions,
                "columns": [
                    {
                        "data": "IdStr" // TweetId
                    },
                    {
                        "data": "Author.ScreenName"  //Author
                    },
                    {
                        "data": "TextAsHtml"  //Tweet
                    },
                    {
                        "data": "CreatedDate"   //Date
                    }
                ],
                "columnDefs": [
                    {
                        "title": "Id",
                        "targets": 0,
                        "render": function (data, type, row) {
                            return '<a href="' + root + row["Author"].ScreenName + "/status/" + row["IdStr"] + '" target="_blank"> ' + data + '</a>';

                        }
                    },
                     {
                         "title": "Id",
                         "targets": 1,
                         "render": function (data, type, row) {
                             return '<a href="' + root + row["Author"].ScreenName + '" target="_blank"> @' + data + '</a>';

                         }
                     },
                     {
                         "title": "Date",
                         "targets": 3,
                         "render": function (data, type, row) {
                             return parseJsonDate(row["CreatedDate"]);

                         }
                     }
                ]
            });
            RefreshLabels(data);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
        }
    }); // end ajax call
}

function GetHashtags() {
    $('#HashtagDT').DataTable();
}

function GetSearchTerms() {
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/GetSearchTerms",
        success: function (data) {
            console.log(data);
            $('#SearchTermsDT').DataTable({
                "sDom": '<"top"lf>rt<"bottom"p><"clear">',
                "lengthMenu": [[25, 35, 50, -1], [25, 35, 50, "All"]],
                "destroy": true,
                "data": data,
                "columns": [
                    {
                        "data": "SearchTerm1" // SearchTerm
                    },
                    {
                        "data": "id"  //id
                    },
                    {
                        "data": "id"  //id
                    }
                ],
                "columnDefs": [
                    {
                        "title": "SearchTerm",
                        "targets": 0
                        ,
                        "render": function (data, type, row) {
                            return '<a  id="' + row["id"] + '"> ' + row["SearchTerm1"] + ' </a>';

                        }
                    },
                    {
                        "title": "RT",
                        "targets": 1
                        ,
                        "render": function (data, type, row) {
                            return '<a class="btn btn-success" onclick="FavoriteTerm(' + row["id"] + ');" >  <i class="fa fa-exchange" ></i> </a>';

                        }
                    },
                    {
                        "title": "LOV",
                        "targets": 2
                        ,
                        "render": function (data, type, row) {
                            return '<a class="btn btn-danger" onclick="RetweetTerm(' + row["id"] + ');" >  <i class="fa fa-heart" ></i> </a>';

                        }
                    }
                ]
            });
            RefreshLabels(data);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
        }
    }); // end ajax call
    
}

function FavoriteTerm(term) {
    var aux = "#" + term;
    //console.log(aux);
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/FavTerm",
        data: " { term : '" + $(aux).text() + "' } ",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
            //$.growl.notice({ message: data.growlMessage });
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
            $.growl.error({ message: "Ajax failed!: " + xhr.error });
        }
    }); // end ajax call
}

function RetweetTerm(term) {
    var aux = "#" + term;
    //console.log(aux);
    $.ajax({
        //cache: false,
        type: "POST",
        contentType: "application/json; charset=utf-8",
        dataType: 'json',
        url: "/Home/RetweetTerm",
        data: " { term : '" + $(aux).text() + "' } ",
        success: function (data) {
            console.log(data);
            RefreshLabels(data);
        },
        error: function (xhr, ajaxOptions, thrownError) {
            console.log(xhr.error);
            console.log(thrownError);
            console.log(ajaxOptions);
            $.growl.error({ message: "Ajax failed!: " + xhr.error });
        }
    }); // end ajax call
}

function InsertTerm() {
    if ($('#termInput').val() != "") {
        $.ajax({
            //cache: false,
            type: "POST",
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            url: "/Home/InsertTerm",
            data: " { term : '" + $('#termInput').val() + "' } ",
            success: function (data) {
                console.log(data);
                RefreshLabels(data);
                GetSearchTerms();
            },
            error: function (xhr, ajaxOptions, thrownError) {
                console.log(xhr.error);
                console.log(thrownError);
                console.log(ajaxOptions);
                $.growl.error({ message: "Ajax failed!: " + xhr.error });
            }
        }); // end ajax call
    } else {
        $('#termInput').focus();
        $.growl.error({ message: "You need to write a term to insert" });
    }
}

$('#tabTweetSomething').click(function () {
    GetOldTweets();
    GetSearchTerms();
});

function parseJsonDate(jsonDate) {
    var date = new Date(parseInt(jsonDate.substr(6)));
    return date;
}

function popMessage(Message, type) {
    if (Message != null && Message != "") { 
        switch (type) {
            case "success":
                $.growl.notice({ message: Message });
                break;
            case "error":
                $.growl.error({ message: Message });
                break;
            case "warning":
                $.growl.warning({ message: Message });
                break;
        }
    }
}