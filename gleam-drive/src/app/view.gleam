import app/model
import gleam/int
import gleam/list
import gleam/string
import gleam/string_builder

pub const index_html = "<!doctype html>
<html>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>gleam-drive</title>
        <script src='https://cdn.tailwindcss.com'></script>
    </head>
    <div class='flex flex-col min-h-screen'>
        <div class='px-4 lg:px-6 h-14 flex items-center'>
            <div class='flex items-center justify-center' href='#'>
               <svg
                  xmlns='http://www.w3.org/2000/svg'
                  width='24'
                  height='24'
                  viewBox='0 0 24 24'
                  fill='none'
                  stroke='currentColor'
                  stroke-width='1'
                  stroke-linecap='round'
                  stroke-linejoin='round'
                  class='h-6 w-6'
                  >
                  <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
               </svg>
               <span class='sr-only'>kode-viewer</span>
            </div>
         </div>
        <main class='flex-1 flex flex-col items-center justify-center space-y-4 text-center'>
          <div class='space-y-2'>
            <h1 class='text-3xl font-bold tracking-tighter sm:text-5xl xl:text-6xl/none'>gleam-drive</h1>
            <p class='max-w-[600px] text-muted-foreground text-gray-500 md:text-xl'>
              Elevate your file-share experience with gleam-drive.
            </p>
          </div>
          <a class='flex justify-center' href='/login'>
            <button class='rounded-md text-sm font-medium bg-background hover:bg-gray-200 text-black font-bold py-2 px-4 border border-accent rounded'>
                Get Started
            </button>
          </a>
        </main>
      </div>
</html>"

pub const login_html = "<!doctype html>
<html>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>gleam-drive</title>
        <script src='https://cdn.tailwindcss.com'></script>
    </head>
    <div class='flex flex-col min-h-screen'>
        <div class='px-4 lg:px-6 h-14 flex items-center'>
            <div class='flex items-center justify-center' href='#'>
               <svg
                  xmlns='http://www.w3.org/2000/svg'
                  width='24'
                  height='24'
                  viewBox='0 0 24 24'
                  fill='none'
                  stroke='currentColor'
                  stroke-width='1'
                  stroke-linecap='round'
                  stroke-linejoin='round'
                  class='h-6 w-6'
                  >
                  <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
               </svg>
               <span class='sr-only'>gleam-drive</span>
            </div>
         </div>
        <main class='flex-1 flex flex-col items-center justify-center text-center'>
          <div class='w-full max-w-md space-y-8'>
            <div>
              <h2 class='mt-6 text-center text-3xl font-bold tracking-tight text-foreground'>Sign in to Gleam Drive</h2>
            </div>
            <form class='space-y-4' action='/login' method='POST'>
              <div>
                <input
                  class='h-10 bg-background text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 relative block w-full appearance-none rounded-md border border-muted px-3 py-2 text-foreground placeholder-muted-foreground focus:z-10 focus:border-primary focus:outline-none focus:ring-primary sm:text-sm'
                  type='email'
                  id='email'
                  autocomplete='email'
                  placeholder='Email'
                  name='email'
                  required
                />
              </div>
              <div>
                <label
                  class='text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 sr-only'
                  for='password'
                >
                  Password
                </label>
                <input
                  class='h-10 bg-background text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 relative block w-full appearance-none rounded-md border border-muted px-3 py-2 text-foreground placeholder-muted-foreground focus:z-10 focus:border-primary focus:outline-none focus:ring-primary sm:text-sm'
                  type='password'
                  id='password'
                  autocomplete='current-password'
                  required
                  placeholder='Password'
                  name='password'
                />
              </div>
              <div>
                <button type='submit' class='rounded-md text-sm w-full bg-background hover:bg-gray-200 text-black font-bold py-2 px-4 border border-accent rounded'>
                  Sign in
              </button>
              </div>
              <div class='text-center'>
                <a class='text-sm font-medium text-muted-foreground text-gray-500 hover:text-gray-900' href='/register'>
                  Don't have an account? Register
                </a>
              </div>
            </form>
          </div>
        </main>
    </div>
</html>"

pub const register_html = "<!doctype html>
<html>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>gleam-drive</title>
        <script src='https://cdn.tailwindcss.com'></script>
    </head>
    <div class='flex flex-col min-h-screen'>
        <div class='px-4 lg:px-6 h-14 flex items-center'>
            <div class='flex items-center justify-center' href='#'>
               <svg
                  xmlns='http://www.w3.org/2000/svg'
                  width='24'
                  height='24'
                  viewBox='0 0 24 24'
                  fill='none'
                  stroke='currentColor'
                  stroke-width='1'
                  stroke-linecap='round'
                  stroke-linejoin='round'
                  class='h-6 w-6'
                  >
                  <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
               </svg>
               <span class='sr-only'>gleam-drive</span>
            </div>
         </div>
        <main class='flex-1 flex flex-col items-center justify-center text-center'>
          <div class='w-full max-w-md space-y-8'>
            <div>
              <h2 class='mt-6 text-center text-3xl font-bold tracking-tight text-foreground'>Register to Gleam Drive</h2>
            </div>
            <form class='space-y-4' action='/register' method='POST'>
              <div>
                <label
                  class='text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 sr-only'
                  for='email'
                >
                  Email
                </label>
                <input
                  class='h-10 bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 relative block w-full appearance-none rounded-md border border-muted px-3 py-2 text-foreground placeholder-muted-foreground focus:z-10 focus:border-primary focus:outline-none focus:ring-primary sm:text-sm'
                  type='email'
                  id='email'
                  autocomplete='email'
                  required
                  placeholder='Email'
                  name='email'
                />
              </div>
              <div>
                <label
                  class='text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70 sr-only'
                  for='password'
                >
                  Password
                </label>
                <input
                  class='h-10 bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 relative block w-full appearance-none rounded-md border border-muted px-3 py-2 text-foreground placeholder-muted-foreground focus:z-10 focus:border-primary focus:outline-none focus:ring-primary sm:text-sm'
                  type='password'
                  id='password'
                  autocomplete='current-password'
                  required
                  placeholder='Password'
                  name='password'
                />
              </div>
              <div>
                <button type='submit' class='rounded-md text-sm w-full bg-background hover:bg-gray-200 text-black font-bold py-2 px-4 border border-accent rounded'>
                  Register
              </button>
              </div>
              <div class='text-center'>
                <a class='text-sm font-medium text-muted-foreground text-gray-500 hover:text-gray-900' href='/login'>
                  Already have an account? Sign in
                </a>
              </div>
            </form>
          </div>
        </main>
    </div>
</html>"

pub const drive_html = "<!doctype html>
<html>
  <head>
      <meta charset='UTF-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1.0'>
      <title>gleam-drive</title>
      <script src='https://cdn.tailwindcss.com'></script>
  </head>
  <div class='flex flex-col h-full w-full'>
    <div class='bg-background border-b flex px-4 sm:px-6 h-14'>
        <div class='flex flex-row justify-between items-center w-full'>
           <a class='flex items-center' href='/drive'>
            <svg
                xmlns='http://www.w3.org/2000/svg'
                width='24'
                height='24'
                viewBox='0 0 24 24'
                fill='none'
                stroke='currentColor'
                stroke-width='1'
                stroke-linecap='round'
                stroke-linejoin='round'
                class='h-6 w-6'
                >
                <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
            </svg>
              <span class='sr-only'>gleam-drive</span>
           </a>
           <div class='flex'>
              <a href='/logout'>
                 <svg
                    xmlns='http://www.w3.org/2000/svg'
                    width='24'
                    height='24'
                    viewBox='0 0 24 24'
                    fill='none'
                    stroke='currentColor'
                    stroke-width='2'
                    stroke-linecap='round'
                    stroke-linejoin='round'
                    class='h-5 w-5'
                    >
                    <path d='M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4' />
                    <polyline points='16 17 21 12 16 7' />
                    <line x1='21' x2='9' y1='12' y2='12' />
                 </svg>
              </a>
           </div>
        </div>
     </div>
     
    <main class='flex flex-col items-center h-full w-full my-5 gap-4'>
        <div class='space-y-6 w-1/2'>
          <div class='flex items-center justify-between'>
              <div class='space-y-1'>
              <h2 class='text-2xl font-bold'>File Upload</h2>
              <p class='text-muted-foreground'>Drag and drop files or click to upload.</p>
              </div>
              <form method=post action='/drive' enctype='multipart/form-data' class='flex flex-row gap-2'>
                  <input class='block my-2 text-sm focus:outline-none' id='uploaded-file' name='uploaded-file' type='file'>
                  <button type='submit' class='inline-flex items-center justify-center whitespace-nowrap rounded-md text-md text-black font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 border border-input bg-background hover:bg-gray-200 hover:text-accent-foreground h-10 px-4 py-2'>
                  Upload File
                  </button>
              </form>
          </div>
          <div>
            FILES_LIST
          </div>
        </div>
    </main>
  </div>
</html>"

pub const share_html = "<!doctype html>
<html>
  <head>
      <meta charset='UTF-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1.0'>
      <title>gleam-drive</title>
      <script src='https://cdn.tailwindcss.com'></script>
  </head>
  <div class='flex flex-col h-full w-full'>
    <div class='bg-background border-b flex px-4 sm:px-6 h-14'>
        <div class='flex flex-row justify-between items-center w-full'>
           <a class='flex items-center' href='/drive'>
            <svg
                xmlns='http://www.w3.org/2000/svg'
                width='24'
                height='24'
                viewBox='0 0 24 24'
                fill='none'
                stroke='currentColor'
                stroke-width='1'
                stroke-linecap='round'
                stroke-linejoin='round'
                class='h-6 w-6'
                >
                <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
            </svg>
              <span class='sr-only'>gleam-drive</span>
           </a>
           <div class='flex'>
              <a href='/logout'>
                 <svg
                    xmlns='http://www.w3.org/2000/svg'
                    width='24'
                    height='24'
                    viewBox='0 0 24 24'
                    fill='none'
                    stroke='currentColor'
                    stroke-width='2'
                    stroke-linecap='round'
                    stroke-linejoin='round'
                    class='h-5 w-5'
                    >
                    <path d='M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4' />
                    <polyline points='16 17 21 12 16 7' />
                    <line x1='21' x2='9' y1='12' y2='12' />
                 </svg>
              </a>
           </div>
        </div>
     </div>
     
    <main class='flex flex-col items-center h-full w-full my-5'>
      <div class='space-y-6 w-1/2'>
      <div class='flex items-center justify-between flex-col gap-4'>
        <div class='flex items-center justify-between mb-4'>
          <div>
            <h1 class='text-2xl font-bold'>Copy this link</h1>
          </div>
        </div>
        <div class='items-center flex justify-end gap-2'>
            <pre class='bg-gray-200 text-xs text-muted-foreground p-2 rounded-md'>DOWNLOAD_LINK</pre>
        </div>
      </div>
      </div>
    </main>
  </div>
</html>"

pub const error_html = "<!doctype html>
<html>
    <head>
        <meta charset='UTF-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1.0'>
        <title>gleam-drive</title>
        <script src='https://cdn.tailwindcss.com'></script>
    </head>
    <div class='flex flex-col min-h-screen'>
        <div class='px-4 lg:px-6 h-14 flex items-center'>
            <div class='flex items-center justify-center' href='#'>
               <svg
                  xmlns='http://www.w3.org/2000/svg'
                  width='24'
                  height='24'
                  viewBox='0 0 24 24'
                  fill='none'
                  stroke='currentColor'
                  stroke-width='1'
                  stroke-linecap='round'
                  stroke-linejoin='round'
                  class='h-6 w-6'
                  >
                  <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
               </svg>
               <span class='sr-only'>gleam-drive</span>
            </div>
         </div>
        <main class='flex-1 flex flex-col items-center justify-center text-center'>
          <div class='w-full max-w-md space-y-8'>
            <div>
              <h2 class='mt-6 text-center text-3xl font-bold tracking-tight text-foreground'>Oops</h2>
            </div>
            <div>
              <p class='text-center text-foreground'>ERROR_MESSAGE</p>
            </div>
            <div>
              <a href='/drive' class='rounded-md text-sm w-full bg-background hover:bg-gray-200 text-black font-bold py-2 px-4 border border-green-700 rounded'>
                Go back
              </a>
            </div>
          </div>
        </main>
    </div>
</html>"

pub const detail_html = "<!doctype html>
<html>
  <head>
      <meta charset='UTF-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1.0'>
      <title>gleam-drive</title>
      <script src='https://cdn.tailwindcss.com'></script>
  </head>
  <div class='flex flex-col h-full w-full'>
    <div class='bg-background border-b flex px-4 sm:px-6 h-14'>
        <div class='flex flex-row justify-between items-center w-full'>
           <a class='flex items-center' href='/drive'>
            <svg
                xmlns='http://www.w3.org/2000/svg'
                width='24'
                height='24'
                viewBox='0 0 24 24'
                fill='none'
                stroke='currentColor'
                stroke-width='1'
                stroke-linecap='round'
                stroke-linejoin='round'
                class='h-6 w-6'
                >
                <path fill-rule='evenodd' clip-rule='evenodd' d='M12 1.25C11.3953 1.25 10.8384 1.40029 10.2288 1.65242C9.64008 1.89588 8.95633 2.25471 8.1049 2.70153L6.03739 3.78651C4.99242 4.33487 4.15616 4.77371 3.51047 5.20491C2.84154 5.65164 2.32632 6.12201 1.95112 6.75918C1.57718 7.39421 1.40896 8.08184 1.32829 8.90072C1.24999 9.69558 1.24999 10.6731 1.25 11.9026V12.0974C1.24999 13.3268 1.24999 14.3044 1.32829 15.0993C1.40896 15.9182 1.57718 16.6058 1.95112 17.2408C2.32632 17.878 2.84154 18.3484 3.51047 18.7951C4.15613 19.2263 4.99233 19.6651 6.03723 20.2134L8.10486 21.2985C8.95628 21.7453 9.64008 22.1041 10.2288 22.3476C10.8384 22.5997 11.3953 22.75 12 22.75C12.6047 22.75 13.1616 22.5997 13.7712 22.3476C14.3599 22.1041 15.0437 21.7453 15.8951 21.2985L17.9626 20.2135C19.0076 19.6651 19.8438 19.2263 20.4895 18.7951C21.1585 18.3484 21.6737 17.878 22.0489 17.2408C22.4228 16.6058 22.591 15.9182 22.6717 15.0993C22.75 14.3044 22.75 13.3269 22.75 12.0975V11.9025C22.75 10.6731 22.75 9.69557 22.6717 8.90072C22.591 8.08184 22.4228 7.39421 22.0489 6.75918C21.6737 6.12201 21.1585 5.65164 20.4895 5.20491C19.8438 4.77371 19.0076 4.33487 17.9626 3.7865L15.8951 2.70154C15.0437 2.25472 14.3599 1.89589 13.7712 1.65242C13.1616 1.40029 12.6047 1.25 12 1.25ZM8.7708 4.04608C9.66052 3.57917 10.284 3.2528 10.802 3.03856C11.3062 2.83004 11.6605 2.75 12 2.75C12.3395 2.75 12.6938 2.83004 13.198 3.03856C13.716 3.2528 14.3395 3.57917 15.2292 4.04608L17.2292 5.09563C18.3189 5.66748 19.0845 6.07032 19.6565 6.45232C19.9387 6.64078 20.1604 6.81578 20.3395 6.99174L12 11.1615L3.66054 6.99174C3.83956 6.81578 4.06132 6.64078 4.34352 6.45232C4.91553 6.07032 5.68111 5.66747 6.7708 5.09563L8.7708 4.04608ZM2.93768 8.30736C2.88718 8.52125 2.84901 8.76412 2.82106 9.04778C2.75084 9.7606 2.75 10.6644 2.75 11.9415V12.0585C2.75 13.3356 2.75084 14.2394 2.82106 14.9522C2.88974 15.6494 3.02022 16.1002 3.24367 16.4797C3.46587 16.857 3.78727 17.1762 4.34352 17.5477C4.91553 17.9297 5.68111 18.3325 6.7708 18.9044L8.7708 19.9539C9.66052 20.4208 10.284 20.7472 10.802 20.9614C10.9656 21.0291 11.1134 21.0832 11.25 21.1255V12.4635L2.93768 8.30736ZM12.75 21.1255C12.8866 21.0832 13.0344 21.0291 13.198 20.9614C13.716 20.7472 14.3395 20.4208 15.2292 19.9539L17.2292 18.9044C18.3189 18.3325 19.0845 17.9297 19.6565 17.5477C20.2127 17.1762 20.5341 16.857 20.7563 16.4797C20.9798 16.1002 21.1103 15.6494 21.1789 14.9522C21.2492 14.2394 21.25 13.3356 21.25 12.0585V11.9415C21.25 10.6644 21.2492 9.7606 21.1789 9.04778C21.151 8.76412 21.1128 8.52125 21.0623 8.30736L12.75 12.4635V21.1255Z' fill='#1C274C'></path>
            </svg>
              <span class='sr-only'>gleam-drive</span>
           </a>
           <div class='flex'>
              <a href='/logout'>
                 <svg
                    xmlns='http://www.w3.org/2000/svg'
                    width='24'
                    height='24'
                    viewBox='0 0 24 24'
                    fill='none'
                    stroke='currentColor'
                    stroke-width='2'
                    stroke-linecap='round'
                    stroke-linejoin='round'
                    class='h-5 w-5'
                    >
                    <path d='M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4' />
                    <polyline points='16 17 21 12 16 7' />
                    <line x1='21' x2='9' y1='12' y2='12' />
                 </svg>
              </a>
           </div>
        </div>
     </div>
     
    <main class='flex flex-col items-center h-full w-full my-5'>
      <div class='space-y-6 w-1/2'>
      <div class='flex items-center justify-between flex-col gap-4'>
        <div class='flex items-center justify-between mb-4'>
          <div>
            <h1 class='text-2xl font-bold text-center'>FILENAME</h1>
            <div class='space-y-4'>
              <div class='bg-muted rounded-md p-4'>
                <div class='grid grid-cols-2 gap-4'>
                  <div>
                    <p class='font-bold text-md'>File Size</p>
                    <p class='text-muted-foreground text-sm'>FILESIZE KB</p>
                  </div>
                  <div>
                    <p class='font-bold text-md'>Last Modified</p>
                    <p class='text-muted-foreground text-sm'>CREATED_AT</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class='items-center flex justify-end gap-2'>
          <form class='flex h-10 w-full' action='/share?filename=FILENAME' method='POST'>
            <div class='flex flex-row justify-center items-center h h-full w-full gap-4'>
              <input
                class='flex w-5/6 bg-background ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 w-full rounded-lg px-4 py-2 border border-accent focus:border-primary focus:ring-primary'
                placeholder='Recepient ...'
                type='email'
                id='recepient'
                name='recepient''
                required
              />
              <button type='submit' class='h-10 rounded-md text-md px-5 bg-background hover:bg-gray-200 font-bold border border-accent rounded'>
                Share
              </button>
            </div>
          </form>  
        </div>
        <div class='items-center flex justify-end gap-2 w-1/2 px-20'>
          <a href='download?token=DOWNLOAD_LINK' class='h-10 w-full rounded-md text-md px-3 bg-background hover:bg-gray-200 font-bold border border-accent rounded'>
            <p class='flex h-full items-center justify-center'>Download</p>
          </a>
        </div>
      </div>
      </div>
    </main>
  </div>
</html>"

pub const no_files_html = "
        <div class='flex flex-col items-center justify-center gap-4'>
          <h1 class='text-muted-foreground text-gray-500 md:text-xl'>No files found</h1>
        </div>
"

pub const some_files_html = "
          <div class='divide-y rounded-md border'>
              FILES
          </div>
"

pub const file_html = "
            <div class='flex items-center justify-between gap-4 p-4'>
                <div class='flex items-center gap-4'>
                    <svg
                    xmlns='http://www.w3.org/2000/svg'
                    width='24'
                    height='24'
                    viewBox='0 0 24 24'
                    fill='none'
                    stroke='currentColor'
                    stroke-width='2'
                    stroke-linecap='round'
                    stroke-linejoin='round'
                    class='h-8 w-8 text-muted-foreground'
                    >
                    <path d='M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z'></path>
                    <path d='M14 2v4a2 2 0 0 0 2 2h4'></path>
                    </svg>
                    <div>
                    <p class='font-medium'>FILENAME</p>
                    <p class='text-sm text-muted-foreground'>FILESIZE KB</p>
                    </div>
                </div>
                <div class='flex items-center gap-2'>
                    <a href='/details?filename=FILENAME' class='inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 hover:bg-gray-200 hover:text-accent-foreground h-10 w-10'>
                    <svg
                        xmlns='http://www.w3.org/2000/svg'
                        width='24'
                        height='24'
                        viewBox='0 0 24 24'
                        fill='none'
                        stroke='currentColor'
                        stroke-width='2'
                        stroke-linecap='round'
                        stroke-linejoin='round'
                        class='h-5 w-5'
                    >
                        <path d='M15.7955 15.8111L21 21M18 10.5C18 14.6421 14.6421 18 10.5 18C6.35786 18 3 14.6421 3 10.5C3 6.35786 6.35786 3 10.5 3C14.6421 3 18 6.35786 18 10.5Z' stroke='#000000' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'></path>
                    </svg>
                    <span class='sr-only'>Details</span>
                    </a>
                </div>
            </div>
"

pub fn render_error_html(message: String) -> String {
  string.replace(error_html, "ERROR_MESSAGE", message)
}

pub fn render_files_html(files: List(model.Upload)) -> String {
  list.map(files, fn(file) {
    string.replace(
      some_files_html,
      "FILES",
      string.replace(
        string.replace(file_html, "FILENAME", file.filename),
        "FILESIZE",
        int.to_string(file.filesize / 1024),
      ),
    )
  })
  |> string_builder.from_strings
  |> string_builder.to_string
}

pub fn render_drives_html(files: List(model.Upload)) -> String {
  case list.length(files) {
    0 -> string.replace(drive_html, "FILES_LIST", no_files_html)
    _ -> string.replace(drive_html, "FILES_LIST", render_files_html(files))
  }
}

pub fn render_detail_html(file: model.Upload, download_link: String) -> String {
  string.replace(
    string.replace(
      string.replace(
        string.replace(detail_html, "FILENAME", file.filename),
        "FILESIZE",
        int.to_string(file.filesize / 1024),
      ),
      "CREATED_AT",
      file.timestamp,
    ),
    "DOWNLOAD_LINK",
    download_link,
  )
}

pub fn render_share_html(download_link: String) -> String {
  string.replace(share_html, "DOWNLOAD_LINK", download_link)
}
