using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;

namespace SilverlightObjectDemo
{
    public partial class MainPage : UserControl
    {
         
        public MainPage(string message)
            : this()
        {
            Model = new MainViewModel { Message = message };
            this.DataContext = Model;
        }
        public MainPage()
        {
            InitializeComponent();
        }

        public MainViewModel Model { get; set; }
    }
}
