import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Identities70346Component } from './identities70346.component';

describe('Identities70346Component', () => {
  let component: Identities70346Component;
  let fixture: ComponentFixture<Identities70346Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Identities70346Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Identities70346Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
