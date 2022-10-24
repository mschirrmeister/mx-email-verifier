# MX Email Verifier

This script checks if a smtp server accepts a certain email address or not. This might be useful, if you for example have a custom domain and create unique email addresses for each site you sign up. Some email services have a delay until the new mailbox/alias becomes active after creation. 

You could just wait a while and hope the mail address is ready when you sign up on a site. But why not verify to see if it is actually valid. You could use a website like https://emailchecker.info/ but why using a service that may collect each address you type in? You can also use telnet, but that is a lot more typing.

## The telnet way

Lookup what the MX servers for a domain are

    dig mx gmail.com

Check if the address exists

    telnet gmail-smtp-in.l.google.com 25
    Trying 2a00:1450:400c:c08::1b...
    Connected to gmail-smtp-in.l.google.com.
    Escape character is '^]'.
    220 mx.google.com ESMTP t14-20020a05600c198e00b003c6f3e3eb7bsi1322386wmq.135 - gsmtp
    ehlo foo
    250-mx.google.com at your service, [2a02:908:176:3bc0:69d6:3800:17de:b489]
    250-SIZE 157286400
    250-8BITMIME
    250-STARTTLS
    250-ENHANCEDSTATUSCODES
    250-PIPELINING
    250-CHUNKING
    250 SMTPUTF8
    mail from:<foo@gmail.com>
    250 2.1.0 OK t14-20020a05600c198e00b003c6f3e3eb7bsi1322386wmq.135 - gsmtp
    rcpt to:<foobar@gmail.com>
    250 2.1.5 OK t14-20020a05600c198e00b003c6f3e3eb7bsi1322386wmq.135 - gsmtp
    quit
    221 2.0.0 closing connection t14-20020a05600c198e00b003c6f3e3eb7bsi1322386wmq.135 - gsmtp
    Connection closed by foreign host.

## More elegant with a script and Docker

The code comes from <https://gist.github.com/arulrajnet/c613bd0fad5de00bab2e> plus some small modifications for **python 3**.

    python MXEmailVerifier.py -e foobar@gmail.com
    
    2022-10-24 13:50:45,373 - EmailVerifier - INFO - Parsed Email id : foobar@gmail.com
    2022-10-24 13:50:45,382 - EmailVerifier - DEBUG - MX host is gmail-smtp-in.l.google.com
    2022-10-24 13:50:45,634 - EmailVerifier - DEBUG - VERIFY 252, b"2.1.5 Send some mail, I'll try my best o12-20020a05600c4fcc00b003b4cb9ebdb5si5724930wmq.181 - gsmtp"
    2022-10-24 13:50:45,654 - EmailVerifier - DEBUG - FROM 250, b'2.1.0 OK o12-20020a05600c4fcc00b003b4cb9ebdb5si5724930wmq.181 - gsmtp'
    2022-10-24 13:50:45,796 - EmailVerifier - DEBUG - RCPT 250, b'2.1.5 OK o12-20020a05600c4fcc00b003b4cb9ebdb5si5724930wmq.181 - gsmtp'
    2022-10-24 13:50:45,796 - EmailVerifier - INFO - foobar@gmail.com, True, b'2.1.5 OK o12-20020a05600c4fcc00b003b4cb9ebdb5si5724930wmq.181 - gsmtp'

Run the docker container and provide the email address as an option

    # providing no option uses the default from the CMD option in the Dockerfile
    docker run -it --rm --name emailcheck mxemailverifier:latest

    # provide the email via "-e <email.you.want.to.check@example.com>
    docker run -it --rm --name emailcheck mxemailverifier:latest -e foobar@gmail.com

