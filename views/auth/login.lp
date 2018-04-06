<?lua
  -- TODO redo doc with luadoc rules
  --
  -- @var login: string|null
  --
  -- TODO html special chars!
?>

<form method="post">
    <!-- <label for="login"><b>Username</b></label> -->
    <input type="text" placeholder="Username/Email" name="login" value="<?= html_encode(login) ?>" required />

    <!-- <label for="psw"><b>Password</b></label> -->
    <input type="password" placeholder="Password" name="password" required />

    <button type="submit" name="submit">Login</button>
</form

<?lua if auth_ok then ?>
  <p>ok: <?= tostring(auth_ok) ?></p>
<?lua end ?>

<?lua if auth_err then ?>
  <p>error: <?= auth_err ?></p>
<?lua end ?>