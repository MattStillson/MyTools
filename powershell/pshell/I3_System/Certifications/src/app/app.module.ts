import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

import { AppComponent } from './app.component';
import { HomeComponent } from './shared/home/home.component';
import { NavbarComponent } from './shared/navbar/navbar.component';
import { Identities70346Component } from './components/identities70346/identities70346.component';
import { Services70347Component } from './components/services70347/services70347.component';
import { Exchange70345Component } from './components/exchange70345/exchange70345.component';
import { Securing70744Component } from './components/securing70744/securing70744.component';
import { Devops70538Component } from './components/devops70538/devops70538.component';
import { Devazure70532Component } from './components/devazure70532/devazure70532.component';

const appRoutes: Routes = [
  { path: 'home', component: HomeComponent },
  { path: 'identities', component: Identities70346Component },
  { path: 'services', component: Services70347Component },
  { path: 'exchange', component: Exchange70345Component },
  { path: 'security', component: Securing70744Component },
  { path: 'devops', component: Devops70538Component },
  { path: 'devazure', component: Devazure70532Component },
  { path: '', redirectTo: 'home', pathMatch: 'full'},
  { path: '**', component: HomeComponent }
];

@NgModule({
  declarations: [
    AppComponent,
    HomeComponent,
    NavbarComponent,
    Identities70346Component,
    Services70347Component,
    Exchange70345Component,
    Securing70744Component,
    Devops70538Component,
    Devazure70532Component
  ],
  imports: [
    BrowserModule,
    RouterModule.forRoot(appRoutes),
    NgbModule.forRoot()
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
