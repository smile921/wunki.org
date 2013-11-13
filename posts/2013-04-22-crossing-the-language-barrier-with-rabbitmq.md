---
title: Crossing the language barrier with RabbitMQ
summary: Cross-language communication with RabbitMQ. In this post I describe how you can connect Erlang and Celery to share tasks across your codebase.
tags: rabbitmq, erlang, celery, django
keywords: erlang, python, rabbitmq, django
---

At the moment we are working hard to get the prototype out the door for
[Gibbon]. Because our team is familiar with [Django], we decided use that for
the website. However, we also need an API to use the iOS client.

In the past we used [Tastypie] to create the API, but I was always drawn to
the [Webmachine] library created by the guys at [Basho].  After fighting
another battle with Tastypie I decided to try out Webmachine.

I loved it! But ... by using [Webmachine] we lost the benefit of a shared
language between Tastypie and Django, both being written in Python. We also
lost the easy access to tasks in [Celery] -- distributed task queue -- for
things like sending email, creating summaries and managing notifications.

## Why Cross-language?

After some messing around I was able to cross the language barrier between
Erlang and Python by using [RabbitMQ] as a translator. This allowed me to
execute tasks on both sides of the codebase and use each language at it's full
potential.

The use of this is great because in a loosely coupled architecture (GOOD) you
can use the programming languages best suitable for the task. For example,
Github uses Erlang for their [Pages] feature and [Ruby] for the Git
integration. Now, when a user should be notified of a change on their Pages,
the email can be send through the same task, no matter what language it's
written in. Keeps the codebase from getting WET (Write Everything Twice).

## Everybody Speaks JSON

To be able to communicate between Python (Django) and Erlang we need to be
sure that the same language is spoken in the messages. On both sides, we will
set the task serializer to JSON. To enable this in Celery (through Django) we
will use the following setting:

```python
CELERY_TASK_SERIALIZER = 'json'
```

Keep in mind that this requires you to use the data types available to JSON in
the arguments to a task function. So, no more passing a Python object as
argument.

On the Erlang side, you can do the following with the [RabbitMQ Erlang client]:

```erlang
%% 1: connect to RabbitMQ
C = amqp_connection:start(#amqp_params_network{username = <<"user">>,
                                               password = <<"pass">>,
                                               virtual_host = <<"virtual">>,
                                               host = "localhost"}),
                                               
%% 2: open a new channel
{ok, Channel} = amqp_connection:open_channel(C),

%% 3: set the message properties
Props = #'P_basic'{content_type = <<"application/json">>},

%% 4: create the payload with the arguments
Payload = {[{task, <<"journals.tasks.send_email">>},
            {id, list_to_binary(UUID)},
            {args, [<<"john@example.com">>, <<"Hello John">>, <<"Simple body">> ]}
            ]},

%% 5: create the message
Msg = #amqp_msg{props = Props, payload = jiffy:encode(Payload)},
            
%% 6: send the message
Publish = #'basic.publish'{exchange = <<"celery">>,
                           routing_key = <<"celery">>},
amqp_channel:cast(Channel, Publish, Msg).
```

Let me walk you through it. First (1) we connect to RabbitMQ by supplying our
credentials and and open up a new channel (2). Then we create a [record] (3)
-- a lot like structs in C -- which says that the value of `content_type` is
`application/json`.

Following that we create the payload (4) which we will be sending along with
the message. The message should be setup according to the [message format] of
Celery. We need at least the following keys:

- task: Name of the task to execute. Your task will be named according to the
  location of the python function: `<project>.<module>.<function>`
- id: Unique id (UUID) of the task.
- args: List of arguments to the task.

Finally (5) we combine the properties of the message and the payload,
convert it to JSON and send (6) it out to RabbitMQ.

## Done!

If you have the Celery workers running, you should see an incoming task in the
console. We are using `amqp_channel:cast/3` to send the message because we want it to be
non-blocking. In Webmachine I return a `202` whenever I call a task through
the REST API. `202` means that the server has received the request and
accepted it for processing. The results can be found at a later time at the
`Location` specified in the header.

That's how easy it can be to cross the barrier between programming
languages. RabbitMQ has [clients] for almost any programming language out
there. You can also do the same with [ZeroMQ] if you are going for speed
instead of guaranteed delivery.

With a few lines of code you can now cross the language barrier and use the
programming language which is most suitable for the task and team working on a
node of your codebase. If it's for internal use, it's quicker and saver that
building an API in HTTP.

[Gibbon]: http://www.gibbon.co
[Webmachine]: https://github.com/basho/webmachine
[Django]: https://www.djangoproject.com/
[TastyPie]: http://django-tastypie.readthedocs.org/
[Basho]: http://www.basho.com/
[Celery]: http://www.celeryproject.org/
[RabbitMQ]: http://www.rabbitmq.com/
[Ruby]: http://www.ruby-lang.org/
[Pages]: http://pages.github.com/
[RabbitMQ Erlang Client]: http://github.com/jbrisbin/amqp_client.git
[record]: http://learnyousomeerlang.com/a-short-visit-to-common-data-structures#records
[message format]: http://docs.celeryproject.org/en/latest/internals/protocol.html#message-format
[clients]: http://www.rabbitmq.com/devtools.html
[zeromq]: http://www.zeromq.org/
