<?lua
  -- TODO redo doc with luadoc rules
  --
  -- @var login: string|null
  --
  -- TODO html special chars!
?>

<?lua if auth_ok then ?>
  <p>ok: <?= tostring(auth_ok) ?></p>
  <a href="/auth/logout">Logout</a>
<?lua end ?>

<?lua if auth_err then ?>
  <p>error: <?= auth_err ?></p>
<?lua end ?>

<?lua if logout then ?>
  <p>logout successful</p>
<?lua end ?>

<form action="/auth/login" method="post">
    <!-- <label for="login"><b>Username</b></label> -->
    <input type="text" placeholder="Username/Email" name="login"
        value="<?= html_encode(login) ?>"
    />

    <!-- <label for="psw"><b>Password</b></label> -->
    <input type="password" placeholder="Password" name="password" required />

    <button type="submit" name="submit">Login</button>
</form

<?lua if session_data_text then ?>
  <p>Session data:</p>
  <pre><?= session_data_text ?></pre>
<?lua end ?>
