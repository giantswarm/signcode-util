var signcode = require('signcode')
var program = require('commander');

// command line arguments
program
  .arguments('<exe_path> <signed_exe_path>')
  .option('-c, --cert <cert_path>', 'Certificate path')
  .option('-k, --key <key_path>', 'Private key path')
  .option('-n, --name <name>', 'A name/title for the executable')
  .option('-s, --site <site>', 'A website URL')
  .action(function(exe_path, signed_exe_path) {
    console.log('EXE: %s', program.exe_path);
    console.log('Signed EXE: %s', program.signed_exe_path);
    console.log('cert_path: %s', program.cert_path);
    console.log('key_path: %s', program.key_path);
    console.log('name: %s', program.name);
    console.log('site: %s', program.site);

    var options = {
      cert: program.cert_path,
      key: program.key_path,
      name: program.name,
      overwrite: false,
      path: program.exe_path,
      resultpath: program.signed_exe_path,
      site: program.site
    }

    signcode.sign(options, function (error) {
      if (error) {
        console.error('Signing failed', error.message);
      } else {
        console.log(options.path + ' is now signed');
        signcode.verify({ path: options.resultpath }, function (error) {
          if (error) {
            console.error('Not signed', error.message);
          } else {
            console.log(options.resultpath + ' is signed');
          }
        });
      }
    });

  });

program.parse(process.argv);

if (typeof program.exe_path === 'undefined') {
   console.error('No exe path given!');
   process.exit(1);
}
