import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { Devazure70532Component } from './devazure70532.component';

describe('Devazure70532Component', () => {
  let component: Devazure70532Component;
  let fixture: ComponentFixture<Devazure70532Component>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ Devazure70532Component ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(Devazure70532Component);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
