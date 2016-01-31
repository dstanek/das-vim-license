vim-license
===========

This Vim plugin allows you to easily add a software license boilerplate
notice to your code. A helper command to fold the license notice has also
been included.

.. note:: License notice folding will only work with the manual foldmethod.

Configuration
-------------

g:license
    The license to use. Currently only 'apache2' is supported and is
    the default.

g:license_copyright_owner
    The owner of the copyright. For example, I have mine set to:
    "David Stanek <dstanek@dstanek.com>".

Commands
--------

:AddLicense
    Add a license notice after the cursor.

:FoldLicense
    Fold the license. (Only works when the foldmethod is set to manual.)

Mappings
--------

This plugin doesn't install any mappings. Here is an example from my own vimrc::

.. code:: vim

    map <silent> <leader>AL <Plug>AddLicense
